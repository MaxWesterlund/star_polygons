require 'ruby2d'

PI = 3.14159265359

SIZE = 720

CIRCLE_RADIUS = 280
LINE_WIDTH = 10

TEXT_MARGIN = 10
TEXT_OFFSET = 5
FONT_SIZE = 30
FONT_FILE = "fira_code.ttf"

BACKGROUND_COLOR = [0.98, 0.98, 0.96, 1]
LINE_COLOR = [0.06, 0.06, 0.11, 1]
TRANSPARENT_LINE_COLOR = [0.06, 0.06, 0.11, 0.34]

def continous?(n, s)
    for i in 1..n - 1 do
        if (s * i) % n == 0
            return false
        end
    end

    return true
end

def draw_polygon(n, s, text)
    Circle.new(
        x: SIZE / 2, y: SIZE / 2,
        radius: CIRCLE_RADIUS,
        sectors: 64,
        color: LINE_COLOR,
    )
    Circle.new(
        x: SIZE / 2, y: SIZE / 2,
        radius: CIRCLE_RADIUS - LINE_WIDTH,
        sectors: 64,
        color: BACKGROUND_COLOR,
    )

    vert_angles = []
    for  i in 0..n - 1 do
        vert_angles << i * 2 * PI / n + 3 * PI / 2
    end

    line_length = CIRCLE_RADIUS - LINE_WIDTH / 2

    for i in 0..n - 1 do
        Line.new(
            x1: Math.cos(vert_angles[i]) * line_length + SIZE / 2, y1: Math.sin(vert_angles[i]) * line_length + SIZE / 2,
            x2: Math.cos(vert_angles[(i + s) % n]) * line_length + SIZE / 2, y2: Math.sin(vert_angles[(i + s) % n]) * line_length + SIZE / 2,
            width: LINE_WIDTH,
            color: TRANSPARENT_LINE_COLOR
        )
    end

    if continous?(n, s)
        text.text = "KONTINUERLIG"
    else
        text.text = "EJ KONTINUERLIG"
    end
end

set width: SIZE, height: SIZE
set title: "Star polygons"
set background: BACKGROUND_COLOR

n = 0
s = 0
n_selected = true

n_text = Text.new(
    "n: #{n}",
    x: TEXT_MARGIN + TEXT_OFFSET, y: TEXT_MARGIN,
    font: FONT_FILE,
    size: FONT_SIZE,
    style: "regular",
    color: LINE_COLOR
)
s_text = Text.new(
    "s: #{s}",
    x: TEXT_MARGIN, y: TEXT_MARGIN * 2 + FONT_SIZE,
    font: FONT_FILE,
    size: FONT_SIZE,
    style: "regular",
    color: LINE_COLOR
)
continous_text = Text.new(
    "",
    x: TEXT_MARGIN, y: SIZE - TEXT_MARGIN - FONT_SIZE,
    font: FONT_FILE,
    size: FONT_SIZE,
    style: "regular",
    color: LINE_COLOR
)

draw_polygon(n, s, continous_text)

on :key_down do |event|
    case event.key
    when "tab"
        n_selected = !n_selected
        if n_selected
            n_text.x = TEXT_MARGIN + TEXT_OFFSET
            s_text.x = TEXT_MARGIN
        else
            s_text.x = TEXT_MARGIN + TEXT_OFFSET
            n_text.x = TEXT_MARGIN
        end
    when "0".."9"
        num = event.key.to_i
        if n_selected
            if n.to_s.length > 1
                n = 99
            elsif n == 0
                n = num
            else
                n = "#{n}#{num}".to_i
            end
            n_text.text = "n: #{n}"
            draw_polygon(n, s, continous_text)
        else
            if s.to_s.length > 1
                s = 99
            elsif s == 0
                s = num
            else
                s = "#{s}#{num}".to_i
            end
            s_text.text = "s: #{s}"
            draw_polygon(n, s, continous_text)
        end
    when "backspace"
        if n_selected
            n = 0
            n_text.text = "n: #{n}"
        else
            s = 0
            s_text.text = "s: #{s}"
        end
        draw_polygon(n, s, continous_text)
    end
end

show
