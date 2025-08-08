import consumer from "channels/consumer"

consumer.subscriptions.create("FeedbackStreamChannel", {
  connected() {
    console.log("Connected to feedback stream")
  },

  disconnected() {
    console.log("Disconnected from feedback stream")
  },

  received(data) {
    // Add the new feedback to the top of the list if we're on the feedbacks page
    const feedbacksList = document.getElementById('feedbacks-list')
    if (feedbacksList && data.html) {
      // If there's a "no feedback" message, remove it
      const emptyState = feedbacksList.querySelector('.text-center.py-12')
      if (emptyState) {
        emptyState.remove()
      }
      
      // Add new feedback at the top
      feedbacksList.insertAdjacentHTML('afterbegin', data.html)
      
      // Add a subtle animation to the new item
      const newFeedback = feedbacksList.firstElementChild
      newFeedback.style.opacity = '0'
      newFeedback.style.transform = 'translateY(-20px)'
      newFeedback.style.transition = 'all 0.3s ease'
      
      setTimeout(() => {
        newFeedback.style.opacity = '1'
        newFeedback.style.transform = 'translateY(0)'
      }, 100)
    }
  }
});
