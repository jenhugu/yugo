// Toggle dropdown on avatar click
document.addEventListener('turbo:load', () => {
  const avatarButton = document.getElementById('avatar-button');
  const dropdownMenu = document.getElementById('dropdown-menu');

  if (avatarButton && dropdownMenu) {
    avatarButton.addEventListener('click', (e) => {
      e.preventDefault();
      dropdownMenu.classList.toggle('show');
    });

    // Close dropdown when clicking outside
    document.addEventListener('click', (e) => {
      if (!avatarButton.contains(e.target) && !dropdownMenu.contains(e.target)) {
        dropdownMenu.classList.remove('show');
      }
    });
  }
});
