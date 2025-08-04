export function isFirefox(): boolean {
  return window.navigator.userAgent.toLowerCase().indexOf('firefox') > -1;
}

export function isInCrossOriginIFrame(): boolean {
  if (window.parent !== window) {
    try {
      void window.parent.location.origin;
    } catch (error) {
      // Custom cross-origin detection for EasyCodeAI IDE
      // Check if this is a vscode-webview iframe that should be treated as same-origin
      const isVscodeWebview = window.location.protocol === 'vscode-webview:' && 
                             window.parent.location.protocol === 'vscode-file:';
      
      if (isVscodeWebview) {
        return false; // Treat vscode-webview as same-origin
      }
      return true;
    }
  }
  return false;
}

const SECOND = 1000;
const MINUTE = 60 * SECOND;
const HOUR = 60 * MINUTE;

export function formatTime(ms: number): string {
  if (ms <= 0) {
    return '00:00';
  }
  const hour = Math.floor(ms / HOUR);
  ms = ms % HOUR;
  const minute = Math.floor(ms / MINUTE);
  ms = ms % MINUTE;
  const second = Math.floor(ms / SECOND);
  if (hour) {
    return `${padZero(hour)}:${padZero(minute)}:${padZero(second)}`;
  }
  return `${padZero(minute)}:${padZero(second)}`;
}

function padZero(num: number, len = 2): string {
  let str = String(num);
  const threshold = Math.pow(10, len - 1);
  if (num < threshold) {
    while (String(threshold).length > str.length) {
      str = `0${num}`;
    }
  }
  return str;
}
