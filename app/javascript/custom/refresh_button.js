// app/javascript/custom/refresh_button.js
document.addEventListener('DOMContentLoaded', function() {
  const refreshButton = document.querySelector('.refresh-button');
  const loadingIndicator = document.getElementById('loading-indicator');
  
  if (refreshButton) {
    refreshButton.addEventListener('click', function(e) {
      // Показываем индикатор загрузки
      loadingIndicator.classList.remove('hidden');
      loadingIndicator.classList.add('inline-flex');
      
      // Делаем кнопку неактивной
      this.classList.add('opacity-50', 'pointer-events-none');
      
      // Анимируем иконку
      const icon = this.querySelector('.refresh-icon');
      if (icon) {
        icon.classList.add('animate-spin');
      }
    });
  }
});