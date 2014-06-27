Planter = (canvas) ->
  that = {}

  baseWidth = ko.observable(5)
  baseTabWidth = ko.computed ->
    baseWidth() / 4

  sideWidth = ko.observable(4)
  sideHeight = ko.observable(5)
  sideTabWidth = ko.computed ->
    sideWidth() / 4

  materialThickness = ko.observable(0.25)

  scale = 50

  polygonToSvg = (poly, translation=[0, 0]) ->
    """
    <polygon
      transform="translate(#{translation[0]}, #{translation[1]})"
      fill="none"
      stroke="black"
      points='#{poly.map(pointToString).join(" ")}'
    />
    """

  pointToString = (point) ->
    "#{point.x}, #{point.y}"

  rect = (w, h) ->
    [
      { x: -w / 2, y: -h / 2 }
      { x: -w / 2, y: h / 2 }
      { x: w / 2, y: h / 2 }
      { x: w / 2, y: -h / 2 }
    ]

  Array::translate = (x, y) ->
    for point in this
      point.x += x
      point.y += y
    this

  Array::scale = (scale) ->
    for point in this
      point.x *= scale
      point.y *= scale
    this

  polygonToFabric = (poly) ->
    fabricPoly = new fabric.Polygon(poly, {
      fill: 'transparent'
      stroke: 'black'
    }, true)
    fabricPoly

  draw = ko.computed ->

    halfWidth = baseWidth() / 2
    halfSideWidth = sideWidth() / 2
    halfSideHeight = sideHeight() / 2
    baseTabOffset = halfWidth - (halfWidth - halfSideWidth + materialThickness() / 2)

    base = rect(baseWidth(), baseWidth()).scale(scale)

    baseTabs = [
      rect(materialThickness(), baseTabWidth()).scale(scale).translate(baseTabOffset*scale, 0)
      rect(materialThickness(), baseTabWidth()).scale(scale).translate(-baseTabOffset*scale, 0)
      rect(baseTabWidth(), materialThickness()).scale(scale).translate(0, -baseTabOffset*scale)
      rect(baseTabWidth(), materialThickness()).scale(scale).translate(0, baseTabOffset*scale)
    ]

    sideTabOffset = halfSideHeight - sideTabWidth() / 2
    sideBaseTabOffset = halfSideWidth - baseTabWidth() / 2

    outsetPanel = [
      {x: -halfSideWidth, y: halfSideHeight }
      {x: halfSideWidth, y: halfSideHeight }
      {x: halfSideWidth, y: halfSideHeight - sideTabOffset }
      {x: halfSideWidth - materialThickness(), y: halfSideHeight - sideTabOffset }
      {x: halfSideWidth - materialThickness(), y: -halfSideHeight + sideTabOffset }
      {x: halfSideWidth, y: -halfSideHeight + sideTabOffset }
      {x: halfSideWidth, y: -halfSideHeight }
      {x: halfSideWidth - sideBaseTabOffset, y: -halfSideHeight }
      {x: halfSideWidth - sideBaseTabOffset, y: -halfSideHeight - materialThickness() }
      {x: -halfSideWidth + sideBaseTabOffset, y: -halfSideHeight - materialThickness() }
      {x: -halfSideWidth + sideBaseTabOffset, y: -halfSideHeight }
      {x: -halfSideWidth, y: -halfSideHeight }
      {x: -halfSideWidth, y: -halfSideHeight + sideTabOffset }
      {x: -halfSideWidth + materialThickness(), y: -halfSideHeight + sideTabOffset }
      {x: -halfSideWidth + materialThickness(), y: halfSideHeight - sideTabOffset }
      {x: -halfSideWidth, y: halfSideHeight - sideTabOffset }
      {x: -halfSideWidth, y: halfSideHeight }
    ].scale(scale)

    insetPanel = [
      {x: -halfSideWidth+ materialThickness(), y: halfSideHeight }
      {x: halfSideWidth- materialThickness(), y: halfSideHeight }
      {x: halfSideWidth- materialThickness(), y: halfSideHeight - sideTabOffset }
      {x: halfSideWidth, y: halfSideHeight - sideTabOffset }
      {x: halfSideWidth, y: -halfSideHeight + sideTabOffset }
      {x: halfSideWidth- materialThickness(), y: -halfSideHeight + sideTabOffset }
      {x: halfSideWidth- materialThickness(), y: -halfSideHeight }
      {x: halfSideWidth - sideBaseTabOffset, y: -halfSideHeight }
      {x: halfSideWidth - sideBaseTabOffset, y: -halfSideHeight - materialThickness() }
      {x: -halfSideWidth + sideBaseTabOffset, y: -halfSideHeight - materialThickness() }
      {x: -halfSideWidth + sideBaseTabOffset, y: -halfSideHeight }
      {x: -halfSideWidth+ materialThickness(), y: -halfSideHeight }
      {x: -halfSideWidth+ materialThickness(), y: -halfSideHeight + sideTabOffset }
      {x: -halfSideWidth, y: -halfSideHeight + sideTabOffset }
      {x: -halfSideWidth , y: halfSideHeight - sideTabOffset }
      {x: -halfSideWidth+ materialThickness(), y: halfSideHeight - sideTabOffset }
      {x: -halfSideWidth + materialThickness(), y: halfSideHeight }
    ].scale(scale)

    svg = ""
    svg += polygonToSvg(base, [baseWidth() * scale / 2 + 1, (baseWidth()*2+materialThickness())* scale / 2])
    svg += polygonToSvg(baseTab, [baseWidth() * scale / 2 + 1, (baseWidth()*2+materialThickness()) * scale / 2]) for baseTab in baseTabs

    svg += polygonToSvg(outsetPanel, [(baseWidth()*1.5 + materialThickness()) * scale, (sideHeight() + materialThickness() * 3) * scale / 2])
    svg += polygonToSvg(outsetPanel, [(baseWidth()*1.5 + materialThickness()) * scale, (sideHeight()*3 + materialThickness() * 7) * scale / 2])

    svg += polygonToSvg(insetPanel, [(baseWidth()*2.5 + materialThickness()) * scale, (sideHeight() + materialThickness() * 3) * scale / 2])
    svg += polygonToSvg(insetPanel, [(baseWidth()*2.5 + materialThickness()) * scale, (sideHeight()*3 + materialThickness() * 7) * scale / 2])

    document.getElementById('output-svg').innerHTML = ""

    setTimeout ->
      document.getElementById('output-svg').innerHTML = svg
    , 10

    svg
  download = ->
    svgHeader = """
      <?xml version="1.0" standalone="no"?>
      <svg xmlns="http://www.w3.org/2000/svg" version="1.0"
        width="1000" height="1000" viewBox="0 0 1000 1000" >
    """
    svgFooter = "</svg>"

    saveAs(new Blob([svgHeader + draw() + svgFooter], {type: 'text/plain'}), 'planter.svg')

  that.download = download
  that.materialThickness = materialThickness
  that.baseWidth = baseWidth
  that.baseTabWidth = baseTabWidth
  that.sideWidth = sideWidth
  that.sideHeight = sideHeight
  that.sideTabWidth = sideTabWidth

  settings = document.getElementById('settings')
  ko.applyBindings that, settings

  that
