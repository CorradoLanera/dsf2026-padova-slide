-- Note del relatore: accenti e gobbo.
-- La vista del relatore (tasto S) non legge slide.scss, quindi colori e dimensioni vanno in linea.
--
-- Accenti: [parola]{.blu} e [parola]{.rosso}, gli stessi colori delle slide; il grassetto si scrive
-- come sempre, **parola**.
-- Gobbo: un blocco :::: {.gobbo} in testa alle note, con le righe da avere sotto gli occhi mentre si
-- parla; esce più grande. Il testo che segue, per chi legge le slide da solo, esce più piccolo e grigio.
local colori = { blu = "#1F6F8B", rosso = "#B5452F" }
local stile_gobbo = "font-size:1.1em;line-height:1.3"
local stile_testo = "font-size:0.8em;color:#6E6E6B;border-top:1px solid #C9C9C5;margin-top:0.8em;padding-top:0.4em"

function Span(el)
  for classe, colore in pairs(colori) do
    if el.classes:includes(classe) then
      el.attributes.style = "color:" .. colore .. ";font-weight:600"
      return el
    end
  end
end

function Div(el)
  if el.classes:includes("gobbo") then
    el.attributes.style = stile_gobbo
    return el
  end
  if el.classes:includes("notes") then
    local gobbo, resto = pandoc.List(), pandoc.List()
    for _, b in ipairs(el.content) do
      if b.t == "Div" and b.classes:includes("gobbo") then
        gobbo:insert(b)
      else
        resto:insert(b)
      end
    end
    if #gobbo > 0 and #resto > 0 then
      gobbo:insert(pandoc.Div(resto, pandoc.Attr("", { "testo" }, { style = stile_testo })))
      el.content = gobbo
      return el
    end
  end
end
