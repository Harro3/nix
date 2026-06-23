{
  config,
  lib,
  pkgs,
  inputs,
  vars,
  ...
}:
{
  options = {
    homemodules.firefox.enable = lib.mkEnableOption "Firefox browser";
  };

  config = lib.mkIf config.homemodules.firefox.enable {
    programs.firefox = {
      enable = true;
      configPath = ".mozilla/firefox";

      profiles.harro = {
        id = 0;
        isDefault = true;
        name = "harro";

        bookmarks.force = true;
        bookmarks.settings = [
          {
            name = "lumo";
            tags = [ "proton" ];
            keyword = "lumo";
            url = "https://lumo.proton.me";
          }
          {
            name = "mail";
            tags = [ "proton" ];
            keyword = "mail";
            url = "https://mail.proton.me";
          }
          {
            name = "drive";
            tags = [ "proton" ];
            keyword = "drive";
            url = "https://drive.proton.me";
          }
          {
            name = "pass";
            tags = [ "proton" ];
            keyword = "pass";
            url = "https://pass.proton.me";
          }
        ];

        settings = {
          "browser.search.defaultEngine" = "DuckDuckGo";

          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredCheckboxes" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.newtabpage.activity-stream.showTopSites" = false;

          "services.sync.prefs.sync.browser.newtabpage.activity-stream.showSponsored" = false;
          "services.sync.prefs.sync.browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.pbmode.enabled" = true;
          "privacy.resistFingerprinting" = true;
          "privacy.firstparty.isolate" = true;
          "privacy.partition.network_state" = true;

          "privacy.clearOnShutdown.downloads" = true;

          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.unified" = false;
          "datareporting.healthreport.uploadEnabled" = false;
          "browser.ping-centre.telemetry" = false;
          "browser.newtabpage.activity-stream.feeds.telemetry" = false;

          "signon.rememberSignons" = false;
          "signon.autofillForms" = false;
          "signon.generation.enabled" = false;
        };

        search.engines = {
          "Nix Packages" = {
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];

            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };
        };
        search.force = true;

        extensions.force = true;
        extensions.packages = with inputs.firefox-addons.packages.${vars.system}; [
          ublock-origin
          youtube-shorts-block
          sponsorblock
          darkreader
          proton-pass
        ];
      };

      policies.ExtensionSettings = {
        # Catppuccin
        "{8446b178-c865-4f5c-8ccc-1d7887811ae3}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/catppuccin-mocha-lavender-git/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };
  };
}
