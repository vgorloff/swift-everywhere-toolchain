var ICUBaseBuilder = require("./ICUBaseBuilder");
const Archs = require("../Archs");

module.exports = class ICUHostBuilder extends ICUBaseBuilder {

  constructor() {
    super(Archs.host)
  }
};
