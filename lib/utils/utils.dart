double setZoomLevel(num metersToClosest) {
    double zoomValue;
    if (metersToClosest < 500) {
      zoomValue = 15.2;
    } else if (metersToClosest < 1000) {
      zoomValue = 14;
    } else if (metersToClosest < 2000) {
      zoomValue = 13;
    } else if (metersToClosest < 4000) {
      zoomValue = 12;
    } else if (metersToClosest < 8000) {
      zoomValue = 11;
    } else if (metersToClosest < 16000) {
      zoomValue = 9.5;
    } else if (metersToClosest < 32000) {
      zoomValue = 8.5;
    } else if (metersToClosest < 64000) {
      zoomValue = 7.5;
    } else if (metersToClosest < 128000) {
      zoomValue = 6.35;
    } else if (metersToClosest < 256000) {
      zoomValue = 6;
    } else {
      zoomValue = 4;
    }
    return zoomValue;
  }

String iconByInstitution(String institutionName) {
    String value;
    switch (institutionName) {
      case "Urgen":
        value = "hospital-15";
        break;
      case "Bombe":
        value = "fire-station-15";
        break;
      case "Carab":
        value = "police-15";
        break;
      default:
        value = null;
        break;
    }
    return value;
  }
