local pdf = require("podofo");
if (not SILE.outputters) then SILE.outputters = {} end

local document
local page
local painter
local pagesize
local font

local cursorX = 0
local cursorY = 0
SILE.outputters.podofo = {
  init = function()
    document = pdf.PdfStreamedDocument(SILE.outputFilename)
    pagesize = pdf.PdfRect()
    pagesize:SetWidth(SILE.documentState.paperSize[1])
    pagesize:SetHeight(SILE.documentState.paperSize[2])
    page = document:CreatePage(pagesize)
    painter = podofo.PdfPainter();
    painter:SetPage(page)
  end,
  newPage = function()
    painter:FinishPage()
    page = document:CreatePage(pagesize)
    painter:SetPage(page)
  end,
  finish = function()
    painter:FinishPage()
    document:Close()
  end,
  setColor = function (self, color)
    painter:SetColor(color.r, color.g, color.b)
  end,
  outputHbox = function (value)
    if not value.glyphNames then return end
    for i = 1,#(value.glyphNames) do
      painter:DrawGlyph(document,cursorX, cursorY, value.glyphNames[i])
    end
  end,
  setFont = function (options)
    font = document:CreateFont(options.font, options.weight > 200, options.style == "italic")
    font:SetFontSize(options.size)
    painter:SetFont(font)
  end,
  drawPNG = function (src, x,y,w,h)
  end,
  moveTo = function (x,y)
    cursorX = x
    cursorY = SILE.documentState.paperSize[2] - y
  end,
  rule = function (x,y,w,d)
    painter:Rectangle(x,y,w,d)
    painter:Close()
    painter:Fill()
  end,
  debugFrame = function (self,f)
  end,
  debugHbox = function(typesetter, hbox, scaledWidth)
    painter:SetColor(0.9,0.9,0.9);
    painter:SetStrokeWidth(0.5);  
    painter:Rectangle(typesetter.frame.state.cursorX, typesetter.frame.state.cursorY+(hbox.height), scaledWidth, hbox.height+hbox.depth);
    if (hbox.depth) then painter:Rectangle(typesetter.frame.state.cursorX, typesetter.frame.state.cursorY+(hbox.height), scaledWidth, hbox.height); end
    painter:Stroke();
    painter:SetColor(0,0,0);
    --cr:move_to(typesetter.frame.state.cursorX, typesetter.frame.state.cursorY);
  end
}

SILE.outputter = SILE.outputters.podofo