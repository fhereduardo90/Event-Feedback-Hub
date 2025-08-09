# Kubernetes Production Deployment Guide

This guide covers deploying, managing, and troubleshooting the Event Feedback Hub Rails application on DigitalOcean Kubernetes.

## Prerequisites

- `doctl` CLI tool installed and configured
- `kubectl` configured for your cluster
- Docker registry access configured

## Initial Setup

### 1. Create Infrastructure

```bash
# Create Kubernetes cluster
doctl kubernetes cluster create event-feedback-hub-cluster \
  --region nyc1 \
  --version 1.33.1-do.3 \
  --size s-2vcpu-2gb \
  --count 1 \
  --auto-upgrade=false

# Get cluster credentials
doctl kubernetes cluster kubeconfig save event-feedback-hub-cluster

# Create databases
doctl databases create event-feedback-hub-db \
  --engine pg --version 17 \
  --size db-s-1vcpu-1gb --region nyc1 --num-nodes 1

doctl databases create event-feedback-hub-redis \
  --engine valkey --version 8 \
  --size db-s-1vcpu-1gb --region nyc1 --num-nodes 1

# Create container registry
doctl registry create event-feedback-hub

# Configure registry authentication
doctl registry login
doctl registry kubernetes-manifest | kubectl apply -f -
```

### 2. Build and Push Docker Image

```bash
# Build production image
docker build --platform linux/amd64 --target production \
  -t registry.digitalocean.com/event-feedback-hub/rails-app:latest .

# Push to registry
docker push registry.digitalocean.com/event-feedback-hub/rails-app:latest
```

### 3. Create Kubernetes Secrets

```bash
# Get database connection strings from DigitalOcean
doctl databases connection event-feedback-hub-db
doctl databases connection event-feedback-hub-redis

# Create secrets (replace with actual values)
kubectl create secret generic rails-secrets \
  --from-literal=database-url="postgresql://user:pass@host:port/db?sslmode=require" \
  --from-literal=redis-url="rediss://user:pass@host:port" \
  --from-literal=secret-key-base="$(openssl rand -hex 64)" \
  --from-literal=pg-host="your-db-host" \
  --from-literal=pg-port="25060" \
  --from-literal=pg-user="doadmin" \
  --from-literal=pg-password="your-password" \
  --from-literal=pg-database="defaultdb"
```

## Deployment Commands

### Deploy Application

```bash
# Apply all manifests in order
kubectl apply -f k8s/migration-job.yaml
kubectl apply -f k8s/rails-deployment.yaml
kubectl apply -f k8s/rails-service.yaml

# Or apply all at once
kubectl apply -f k8s/
```

### Check Deployment Status

```bash
# Check all resources
kubectl get all

# Check pods
kubectl get pods
kubectl get pods -o wide

# Check services and external IP
kubectl get services

# Check deployments
kubectl get deployments

# Check jobs
kubectl get jobs
```

## Managing the Application

### Scaling

```bash
# Scale deployment
kubectl scale deployment rails-app --replicas=2

# Check current replica count
kubectl get deployment rails-app
```

### Rolling Updates

```bash
# Update image
kubectl set image deployment/rails-app rails-app=registry.digitalocean.com/event-feedback-hub/rails-app:v2

# Check rollout status
kubectl rollout status deployment rails-app

# Rollback if needed
kubectl rollout undo deployment rails-app
```

### Restart Deployment

```bash
# Restart all pods
kubectl rollout restart deployment rails-app

# Force clean restart (for memory-constrained nodes)
kubectl scale deployment rails-app --replicas=0
sleep 5
kubectl scale deployment rails-app --replicas=1
```

## Database Operations

### Run Migrations

```bash
# Run a one-time migration job
kubectl apply -f k8s/migration-job.yaml

# Check migration job logs
kubectl logs job/rails-db-migrate

# Delete completed job
kubectl delete job rails-db-migrate
```

### Manual Migration Commands

```bash
# Run migrations directly in a pod
kubectl exec deployment/rails-app -- bundle exec rails db:migrate

# Run migrations in production environment
kubectl exec deployment/rails-app -- bundle exec rails db:migrate RAILS_ENV=production

# Run seed data
kubectl exec deployment/rails-app -- bundle exec rails db:seed

# Create SolidCable tables
kubectl exec deployment/rails-app -- bundle exec rails db:migrate:cable
```

## Debugging and Troubleshooting

### View Logs

```bash
# View current logs
kubectl logs deployment/rails-app

# Follow logs in real-time
kubectl logs deployment/rails-app -f

# View logs from specific pod
kubectl logs rails-app-[pod-id] -f

# View logs with timestamps
kubectl logs deployment/rails-app --timestamps=true

# View previous container logs (if pod restarted)
kubectl logs rails-app-[pod-id] --previous
```

### Access Rails Console

```bash
# Open Rails console
kubectl exec -it deployment/rails-app -- rails console

# Run specific Rails commands
kubectl exec deployment/rails-app -- rails runner "puts User.count"

# Check database connectivity
kubectl exec deployment/rails-app -- rails runner "puts ActiveRecord::Base.connection.execute('SELECT version()').first"
```

### Shell Access

```bash
# Get interactive shell
kubectl exec -it deployment/rails-app -- /bin/sh

# Run bash if available
kubectl exec -it deployment/rails-app -- /bin/bash

# Execute specific commands
kubectl exec deployment/rails-app -- ls -la
kubectl exec deployment/rails-app -- cat config/database.yml
kubectl exec deployment/rails-app -- bundle exec rails -T
```

### Pod Information

```bash
# Describe pod details
kubectl describe pod [pod-name]

# Get pod YAML configuration
kubectl get pod [pod-name] -o yaml

# Check resource usage
kubectl top pods
kubectl top nodes
```

### Debug Container Issues

```bash
# Check pod events
kubectl get events --sort-by=.metadata.creationTimestamp

# Debug networking
kubectl exec deployment/rails-app -- nslookup kubernetes.default
kubectl exec deployment/rails-app -- wget -qO- http://kubernetes.default/api/

# Check environment variables
kubectl exec deployment/rails-app -- env | grep -E "(RAILS|PG|REDIS)"
```

## Secret Management

### View Secrets

```bash
# List secrets
kubectl get secrets

# View secret details (base64 encoded)
kubectl get secret rails-secrets -o yaml

# Decode secret values
kubectl get secret rails-secrets -o jsonpath='{.data.database-url}' | base64 -d
```

### Update Secrets

```bash
# Update a secret value
kubectl patch secret rails-secrets -p '{"data":{"secret-key-base":"'$(echo -n "new-secret" | base64)'"}}'

# Recreate secret
kubectl delete secret rails-secrets
kubectl create secret generic rails-secrets \
  --from-literal=database-url="new-url" \
  # ... other secrets
```

### Query Environment Variables from Secrets

```bash
# View all environment variables in pod
kubectl exec deployment/rails-app -- env

# Check specific secret-sourced variables
kubectl exec deployment/rails-app -- env | grep PG
kubectl exec deployment/rails-app -- printenv PGPASSWORD

# Verify database connection using env vars
kubectl exec deployment/rails-app -- psql "$DATABASE_URL" -c "SELECT version();"
```

## Health Checks and Monitoring

### Check Application Health

```bash
# Test application endpoint
kubectl exec deployment/rails-app -- curl -I http://localhost:3000

# Check readiness probe
kubectl describe pod [pod-name] | grep -A5 "Readiness"

# Test external access
curl -I http://[EXTERNAL-IP]
```

### Monitor Resources

```bash
# Resource usage
kubectl top pods
kubectl top nodes

# Detailed node information
kubectl describe node

# Check pod resource requests/limits
kubectl describe pod [pod-name] | grep -A10 "Requests\|Limits"
```

## Cleanup Commands

### Clean Up Resources

```bash
# Delete all application resources
kubectl delete -f k8s/

# Delete specific resources
kubectl delete deployment rails-app
kubectl delete service rails-service
kubectl delete job rails-db-migrate
kubectl delete secret rails-secrets

# Delete completed jobs
kubectl delete job --field-selector=status.successful=1
```

### Clean Up Infrastructure

```bash
# Delete databases
doctl databases delete event-feedback-hub-db --force
doctl databases delete event-feedback-hub-redis --force

# Delete container registry
doctl registry delete event-feedback-hub --force

# Delete Kubernetes cluster
doctl kubernetes cluster delete event-feedback-hub-cluster --force
```

## Common Issues and Solutions

### Pod Stuck in Pending

```bash
# Check node resources
kubectl describe node
kubectl top nodes

# Check for resource constraints
kubectl describe pod [pod-name] | grep -A5 "Events"

# Solution: Scale down temporarily
kubectl scale deployment rails-app --replicas=0
kubectl scale deployment rails-app --replicas=1
```

### Database Connection Issues

```bash
# Verify database URL
kubectl exec deployment/rails-app -- printenv DATABASE_URL

# Test database connectivity
kubectl exec deployment/rails-app -- bundle exec rails runner "ActiveRecord::Base.connection.execute('SELECT 1')"

# Check DNS resolution
kubectl exec deployment/rails-app -- nslookup [database-host]
```

### Image Pull Issues

```bash
# Check image pull secrets
kubectl get secrets
kubectl describe secret registry-event-feedback-hub

# Recreate registry authentication
doctl registry kubernetes-manifest | kubectl apply -f -

# Verify image exists
doctl registry repository list-tags event-feedback-hub/rails-app
```

### SSL/TLS Issues

```bash
# Check SSL configuration
kubectl exec deployment/rails-app -- openssl s_client -connect [db-host]:25060

# Verify SSL environment
kubectl exec deployment/rails-app -- printenv | grep SSL
```

## Useful One-Liners

```bash
# Quick deployment status
kubectl get pods,services,jobs --selector=app=rails-app

# Restart and follow logs
kubectl rollout restart deployment rails-app && kubectl logs deployment/rails-app -f

# Check all environment variables from secrets
kubectl exec deployment/rails-app -- bash -c 'echo "DATABASE_URL: $DATABASE_URL"; echo "REDIS_URL: $REDIS_URL"'

# Quick Rails console one-liner
kubectl exec -it deployment/rails-app -- rails runner "puts Rails.env; puts Feedback.count"

# Port forward for local access
kubectl port-forward service/rails-service 3000:80

# Emergency debug pod
kubectl run debug --image=busybox -it --rm -- /bin/sh
```

## Production Checklist

Before going live:

- [ ] Secrets are properly configured and not exposed in YAML
- [ ] Resource limits are appropriate for your node size
- [ ] Health checks are working correctly
- [ ] External IP is accessible and load balancer is healthy
- [ ] Database migrations have been applied
- [ ] Monitoring and logging are configured
- [ ] Backup strategy is in place
- [ ] SSL certificates are configured (if using HTTPS)
- [ ] Security policies are applied
- [ ] Auto-scaling is configured if needed

---

## Quick Reference

| Task | Command |
|------|---------|
| View pods | `kubectl get pods` |
| View logs | `kubectl logs deployment/rails-app -f` |
| Rails console | `kubectl exec -it deployment/rails-app -- rails console` |
| Shell access | `kubectl exec -it deployment/rails-app -- /bin/sh` |
| Run migration | `kubectl exec deployment/rails-app -- rails db:migrate` |
| Restart app | `kubectl rollout restart deployment rails-app` |
| Scale app | `kubectl scale deployment rails-app --replicas=N` |
| Port forward | `kubectl port-forward service/rails-service 3000:80` |
| Delete resources | `kubectl delete -f k8s/` |