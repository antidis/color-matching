require 'color-rgb'

class ColorLibrary
  paints = {
    "Abaddon Black" => "000000",
    "Averland Sunset" => "fbba00",
    "Caledor Sky" => "3a679b",
    "Caliban Green" => "003b1e",
    "Castellan Green" => "3a4c21",
    "Catachan Fleshtone" => "4e3831",
    "Celestra Grey" => "9baeae",
    "Ceramite White" => "ffffff",
    "Corax White" => "ececec",
    "Corvus Black" => "1d1d1b",
    "Daemonette Hide" => "746e8b",
    "Death Guard Green" => "737a51",
    "Death Korps Drab" => "4a4c40",
    "Deathworld Forest" => "686d2d",
    "Dryad Bark" => "3b352e",
    "Gal Vorbak Red" => "55323e",
    "Grey Seer" => "c6c6c6",
    "Incubi Darkness" => "0e4445",
    "Ionrach Skin" => "ddccb9",
    "Jokaero Orange" => "e52d12",
    "Kantor Blue" => "0d244e",
    "Khorne Red" => "6b0e02",
    "Lupercal Green" => "022c2f",
    "Macragge Blue" => "193a79",
    "Mechanicus Standard Grey" => "454f50",
    "Mephiston Red" => "9b130b",
    "Morghast Bone" => "c9b483",
    "Mournfang Brown" => "681409",
    "Naggaroth Night" => "443655",
    "Night Lords Blue" => "043660",
    "Nocturne Green" => "1e322b",
    "Phoenician Purple" => "471352",
    "Rakarth Flesh" => "aca394",
    "Ratskin Flesh" => "b36d48",
    "Rhinox Hide" => "4e3433",
    "Screamer Pink" => "821a41",
    "Screaming Bell" => "ae430a",
    "Steel Legion Drab" => "685733",
    "Stegadon Scale Green" => "014360",
    "The Fang" => "4a667b",
    "Thousand Sons Blue" => "025573",
    "Wraithbone" => "e6dbbe",
    "Zandri Dust" => "a89757",
    "Administratum Grey" => "9da099",
    "Ahriman Blue" => "007c8f",
    "Alaitoc Blue" => "305688",
    "Altdorf Guard Blue" => "2a4b9b",
    "Baharroth Blue" => "64bfce",
    "Balor Brown" => "925e06",
    "Baneblade Brown" => "99816b",
    "Bestigor Flesh" => "d68c50",
    "Bloodreaver Flesh" => "784d4b",
    "Blue Horror" => "b0c2d8",
    "Cadian Fleshtone" => "cb7853",
    "Calgar Blue" => "456eb4",
    "Dark Reaper" => "425553",
    "Dawnstone" => "7a7d74",
    "Deathclaw Brown" => "b96a52",
    "Dechala Lilac" => "c0a8d0",
    "Deepkin Flesh" => "deded2",
    "Doombull Brown" => "5e0c0a",
    "Dorn Yellow" => "fff054",
    "Elysian Green" => "81932f",
    "Eshin Grey" => "545658",
    "Evil Sunz Scarlet" => "bf1111",
    "Fenrisian Grey" => "789dbb",
    "Fire Dragon Bright" => "f0844b",
    "Flash Gitz Yellow" => "ffed00",
    "Flayed One Flesh" => "e8c087",
    "Fulgrim Pink" => "f4b7d3",
    "Gauss Blaster Green" => "90c4aa",
    "Genestealer Purple" => "7c5ba3",
    "Gorthor Brown" => "c07009",
    "Hoeth Blue" => "507eb4",
    "Kabalite Green" => "008560",
    "Kakophoni Purple" => "9173ae",
    "Karak Stone" => "c1a068",
    "Kislev Flesh" => "c9a073",
    "Krieg Khaki" => "c9c17e",
    "Loren Forest" => "5c7426",
    "Lothern Blue" => "3ba1d0",
    "Lugganath Orange" => "f4a188",
    "Moot Green" => "56aa2e",
    "Nurgling Green" => "8fa15f",
    "Ogryn Camo" => "a9ae40",
    "Pallid Wych Flesh" => "d6d5c4",
    "Phalanx Yellow" => "fede32",
    "Pink Horror" => "96325c",
    "Russ Grey" => "54758a",
    "Screaming Skull" => "dad8a6",
    "Skarsnik Green" => "5f8f67",
    "Skavenblight Dinge" => "4f4740",
    "Skrag Brown" => "944b07",
    "Slaanesh Grey" => "958f9a",
    "Sons of Horus Green" => "08566a",
    "Sotek Green" => "0e6875",
    "Squig Orange" => "af4d3e",
    "Stormvermin Fur" => "7c7269",
    "Straken Green" => "6f8515",
    "Sybarite Green" => "3aa063",
    "Tallarn Sand" => "aa7d00",
    "Tau Light Ochre" => "c16f09",
    "Teclis Blue" => "397bbf",
    "Temple Guard Blue" => "39998d",
    "Thunderhawk Blue" => "467379",
    "Troll Slayer Orange" => "eb641e",
    "Tuskgor Fur" => "8e3733",
    "Ulthuan Grey" => "d3e3de",
    "Ungor Flesh" => "dbac62",
    "Ushabti Bone" => "c5c180",
    "Vulkan Green" => "304635",
    "Warboss Green" => "3c7c54",
    "Warpfiend Grey" => "757179",
    "Warpstone Glow" => "277227",
    "Wazdakka Red" => "8d1207",
    "White Scar" => "ffffff",
    "Wild Rider Red" => "e12318",
    "Word Bearers Red" => "650c12",
    "Xereus Purple" => "4b225b",
    "Yriel Yellow" => "ffd900",
    "Zamesi Desert" => "e0a407"
  }

  COLORS = []

  paints.each_key do |name|
    paint_hex = paints[name]
    red = paint_hex[0, 2].to_i(16)
    green = paint_hex[2, 2].to_i(16)
    blue = paint_hex[4, 2].to_i(16)
    color = Color::RGB.new(red, green, blue)
    COLORS << {
      name: name,
      hex: paint_hex,
      color_rgb: color,
      lab: color.to_lab,
      rgb: {
        red: red,
        green: green,
        blue: blue
      }
    }
  end

  def self.nearest_available_color(color_rgb)
    COLORS.sort do |a, b|
      Color::Comparison.distance(color_rgb, a[:color_rgb]) <=> Color::Comparison.distance(color_rgb, b[:color_rgb])
    end.first
  end

  def self.nearest_colors(target_color, quantity=nil)
    found_colors = COLORS.each do |color|
      color[:distance] = Color::Comparison.distance(target_color[:color_rgb], color[:color_rgb])
    end.sort do |a, b|
      a[:distance] <=> b[:distance]
    end
    if quantity.nil?
      found_colors
    else
      found_colors.slice(0, quantity)
    end
  end
end
