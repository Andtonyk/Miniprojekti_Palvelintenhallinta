    #srv/salt/ourpython/init.sls
      mypkgs:
        pkg.installed:
          - pkgs:
            - python3
            - python3-pip
            - build-essential
            - libssl-dev
            - libffi-dev
            - python3-dev
            - python3-venv
