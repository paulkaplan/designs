ko.bindingHandlers.numericValue = init: (element, valueAccessor, allBindingsAccessor) ->
  value = valueAccessor()
  element.value = value() + '"'

  element.onchange = ->
    strValue = @value.replace('"', '')
    numValue = parseFloat(strValue)
    numValue = if isNaN(numValue) then 0 else numValue
    @value = numValue + '"'
    value numValue
