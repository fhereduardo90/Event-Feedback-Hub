SecureHeaders::Configuration.default do |config|
  config.hsts = "max-age=#{1.year.to_i}; includeSubdomains; preload"
  config.x_frame_options = "DENY"
  config.x_content_type_options = "nosniff"
  config.x_xss_protection = "1; mode=block"
  config.x_download_options = "noopen"
  config.x_permitted_cross_domain_policies = "none"
  config.referrer_policy = %w[origin-when-cross-origin strict-origin-when-cross-origin]

  config.csp = {
    default_src: %w['self'],
    img_src: %w['self' data: https:],
    script_src: %w['self' 'unsafe-inline'],
    style_src: %w['self' 'unsafe-inline'],
    connect_src: %w['self' ws: wss:],
    font_src: %w['self'],
    object_src: %w['none'],
    frame_src: %w['none']
  }
end
