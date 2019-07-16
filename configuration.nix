# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
#      ./vim.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.device = "/dev/sda3";
  boot.initrd.luks.devices = [
    {
      name = "root";
      device = "/dev/sda3";
      preLVM = true;
    }
  ];

  networking.hostName = "constant"; # Define your hostname.
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.extraHosts = ''
    192.168.1.50 klee
  '';

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n = {
    consoleFont = "ProggyClean";
    consoleKeyMap = "de";
    defaultLocale = "en_EN.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  fileSystems."/mnt/klee" = {
    device = "klee:/media/shares";
    fsType = "nfs";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    binutils-unwrapped
    coreutils
    curl
    cmake
    dmenu
    docker
    docker_compose
    dzen2
    lsof
    file
    gcc
    git
    gnutls
    gnumake
    gnupg
    htop
    lm_sensors
    mplayer
    openssl
    pwgen
    rxvt_unicode
    slock
    tmux
    vim_configurable
    vlc
    wget
    wpa_supplicant_gui
    zathura

    gimp
    inkscape
    keepassx2
    networkmanagerapplet
    thunderbird

    haskellPackages.ghc
    haskellPackages.xmonad
    haskellPackages.xmonad-contrib
    haskellPackages.xmonad-extras

  ];

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts
    dina-font
    proggyfonts
    screen
  ];

  programs.bash.enableCompletion = true;
  programs.slock.enable = true;
  programs.ssh.startAgent = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  #programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  #services.openssh.passwordAuthentication = false;

  services.locate.enable = true;


  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  # services.xserver.layout = "de";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  services.xserver = {
    enable = true;
    libinput.enable = true;
    layout = "de";
    # displayManager.sddm.enable = true;
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = haskellPackages: [
        haskellPackages.xmonad-contrib
        haskellPackages.xmonad-extras
        haskellPackages.xmonad
      ]; 
    };
   windowManager.default = "xmonad";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ub = {
     isNormalUser = true;
     uid = 1000;
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.09"; # Did you read the comment?

  # enabvle docker service and allow access for ub
  virtualisation.docker.enable = true;
  users.users.ub.extraGroups = [ "docker" ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = false;
    };
  };

}
