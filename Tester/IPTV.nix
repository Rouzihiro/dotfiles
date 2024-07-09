{
  pkgs,
  lib,
}: let
  m3u-to-tsv = ''
    ${pkgs.gnused}/bin/sed '/#EXTM3U/d;/#EXTINF/s/.*,//g' $out | ${pkgs.coreutils}/bin/paste -d'\t' - - > $out.tmp
    mv $out.tmp $out
  '';

  live-tv = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/Free-TV/IPTV/39a573d7a428ca1b2ffeec422751a01d37e59e94/playlist.m3u8";
    hash = "sha256-GBJBJN1AwwtO8HYrD0y3/qPCiK48IXyjt93s6DF/7Yo=";
    postFetch = m3u-to-tsv;
  };

  kodi-tv = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/jnk22/kodinerds-iptv/3f35761b7edcfb356d22cac0e561592ba589c20b/iptv/kodi/kodi_tv.m3u";
    sha256 = "sha256-EZEshHWUejLTy6qsBhELfaYdDpQ/uqPsZa1JA0mb7h0=";
    postFetch = m3u-to-tsv;
  };
in
  pkgs.writers.writeDashBin "mpv-tv" ''
    cat ${kodi-tv} ${live-tv} | ${pkgs.mpv}/bin/mpv --force-window=yes "$(${pkgs.dmenu}/bin/dmenu -i -l 5 | ${pkgs.coreutils}/bin/cut -f2)"
  ''
