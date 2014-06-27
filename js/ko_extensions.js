ko.bindingHandlers.numericValue = {
    init: function (element, valueAccessor, allBindingsAccessor) {
      var value = valueAccessor();

      element.value = value() + '"';
      element.onchange = function () {
          var strValue = this.value.replace('"', '');
          var numValue = parseFloat(strValue)
          numValue = isNaN(numValue) ? 0 : numValue;
          this.value = numValue + '"';
          value(numValue);
      };
    }
};
