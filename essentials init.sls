  #srv/salt/essentials/init.sls
    mypkgs:
      pkg.installed:
        - pkgs:
          - micro
          - curl
          - git
          - vlc
