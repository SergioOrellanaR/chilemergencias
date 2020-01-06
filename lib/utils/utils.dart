double setZoomLevel(num closestInformation) {
    double zoomValue;
    if (closestInformation < 500) {
      zoomValue = 15.2;
    } else if (closestInformation < 1000) {
      zoomValue = 14;
    } else if (closestInformation < 2000) {
      zoomValue = 13;
    } else if (closestInformation < 4000) {
      zoomValue = 12;
    } else if (closestInformation < 8000) {
      zoomValue = 11;
    } else if (closestInformation < 16000) {
      zoomValue = 9.5;
    } else if (closestInformation < 32000) {
      zoomValue = 8.5;
    } else if (closestInformation < 64000) {
      zoomValue = 7.5;
    } else if (closestInformation < 128000) {
      zoomValue = 6.35;
    } else if (closestInformation < 256000) {
      zoomValue = 6;
    } else {
      zoomValue = 4;
    }
    return zoomValue;
  }