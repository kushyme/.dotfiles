{
  username = "erikp";
  host = "default";
  system = "x86_64-linux";
  osLanguage = "en_US.UTF-8";
  keyboardLayout = "de_DE.UTF-8";
  stateVersion = "26.05";
  modules = {
    console = {
      atuin = true;
      fish = false;
      zsh = true;
    };
    driver = {
      nvidia = false;
      amdgpu = false;
    };
    gui = {
      gnome = true;
    };
    software = {
      display-link = true;
      docker = true;
      flatpak = false;
      git = true;
      noisetorch = true;
      tmux = false;
      wine = false;
      ollama = false;
    };
    systemSettings = {
      bootanimation = true;
      gaming = false;
      virtualization = false;
    };
  };
  git = {
    lfs = true;
    extraConfig = {
      defaultBranch = "main";
      credential-helper = "store";
    };
    credentials = {
      email = "159010501+kushyme@users.noreply.github.com";
      name = "kushyme";
    };
    includes = [];
  };
  gnome = {
    fav-icon = [];
    idle-delay = 0;
  };
}
