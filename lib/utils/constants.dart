// ignore_for_file: constant_identifier_names, non_constant_identifier_names
// ignore_for_file: camel_case_types

enum eDeviceStatusFlag {
  SERIAL_PARSED,
  CODE_GENERATED,
  CONNECTED_TO_USER,
  RETURN_FEED_START,
  IDLE,
  WELCOME,
  OFFLINE,
  LOADING,
  UPDATE_REQUIRED,
  UPDATE_AVAILABLE,
  UPDATE_IN_PROGRESS,
  ALREADY_OWNED,
  INITIAL,
}

enum DeviceUpdateState {
  UPDATE_AVAILABLE,
  UPDATE_REQUIRED,
  UP_TO_DATE,
  UPDATE_IN_PROGRESS,
}

enum ePlaybackStatus {
  STREAM,
  PLAY,
  PLAY_WELCOME,
  STOP,
  PAUSE,
  SET_LOOP_FLAG,
  PREVIOUS,
  NEXT,
  SEEK,
}

enum eLockStatus {
  UNSET,
  LOCKED,
  UNLOCKED,
}

enum DeviceOfflineSyncEvent {
  SYNC_ALL,
  SYNC_CONTENT,
  SYNC_PLAYLIST,
}

const NM_CONNECTIVITY_PORTAL = 2;
const NM_CONNECTIVITY_LIMITED = 4;
const NM_CONNECTIVITY_FULL = 5;

const NM_CONNECTIVITY = 'Connectivity';

const CONNECTED_CAMERAS_COMMAND = 'v4l2-ctl --list-devices';
const CONNECTED_MICS_COMMAND = 'arecord --list-devices';
const CONNECTED_SPEAKERS_COMMAND = 'aplay --list-devices';
const CONNECTED_TOUCHSCREEN_COMMAND = 'libinput list-devices';

const CAPTIVE_PORTAL_REDIRECT_URL = 'http://connectivity-check.ubuntu.com';
const MEDIA_STREAM_URL = 'rtp://127.0.0.1:22222';

const NETWORK_SCAN_COMMAND = 'nmcli -t -f '
    'SSID,SECURITY,FREQ,RATE,SIGNAL,DEVICE,IN-USE '
    'dev wifi list';

const NETWORK_GET_LOCAL_IPADDRESS_COMMAND = 'hostname -I';

const NETWORK_CONTROL_COMMAND = 'nmcli radio wifi';
const NETWORK_IS_CONNECTED_COMMAND = 'nmcli -t -f name connection'
    ' show --active';

const NETWORK_CONNECT_COMMAND =
    'nmcli device wifi connect "NETWORK_SSID" password "NETWORK_PASSWORD"';

const NETWORK_CONNECT_SAVED_COMMAND = 'nmcli con up "SSID"';

const NETWORK_AUTOCONNECT_CHANGE_COMMAND =
    'nmcli connection modify "SSID" autoconnect "[true/yes/on]|[false/no/off]"';

const NETWORK_AUTOCONNECT_PRIORITY_CHANGE_COMMAND =
    'nmcli connection modify "SSID" connection.autoconnect-priority "[0-999]"';

const NETWORK_FORGET_COMMAND = 'nmcli connection delete "CONNECTION_UUID"';
const NETWORK_CONNECTION_STATUS_COMMAND = 'nmcli -t -f '
    'NAME,UUID,AUTOCONNECT,TYPE '
    'connection';

const SPEAKER_TEST_COMMAND = 'speaker-test -c2';
const RECORD_COMMAND = 'arecord -f cd';
const PLAY_COMMAND = 'aplay /tmp/test.wav';

const STATUS_CHANGE_EVENT = 'statusChange';
const PLAYBACK_EVENT = 'playback/epic_change';
const PLAYBACK_GET_EVENT = 'playback/get';
const LOCK_STATUS_EVENT = 'lockStatus';
const PLAYBACK_UPDATE_EVENT = 'playback/epic_update';
const TOUCH_SCREEN_UPDATE_EVENT = 'touchscreenChanged';
const CAMERA_UPDATE_EVENT = 'cameraChanged';
const CLOUD_CONNECTIVITY = 'cloudConnectivity';
const SNAP_SUCCESSFUL_UPDATED = 'successfulSnapUpdate';
const SNAP_UPDATE_PROGRESS = 'snapsUpdateProgress';
const DEVICE_INFO_UPDATE = 'updateDeviceInfo';
const DBUS_CONNECTION_EVENT = 'dbus/nm-connectivity';
