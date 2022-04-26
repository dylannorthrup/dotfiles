package Dylan::EColor;

# We use this to set the value of 'normal'
use Term::ANSIColor;

BEGIN {
  use Exporter;
  use vars qw($VERSION @ISA @EXPORT_OK %EXPORT_TAGS);

  $VERSION    = '0.001';
  @ISA        = qw(Exporter);
  @EXPORT     = qw(get_extended_colors_hash);
  @EXPORT_OK  = qw(
    rgb
  );

  %EXPORT_TAGS = (
    all        => [ @EXPORT_OK ],
  );
}

my ($fg, $bg) = ("38", "48");

sub rgb {
  $intro = shift;
  $R = shift;
  $G = shift;
  $B = shift;
  $c = "\e[1;" . $intro . ";2;" . $R . ";" . $G . ";" . $B . "m";
  return $c;
}

## Color_name  Hex rgb  Decimal
%colormap = qw(
  black 0_0_0
  silver 192_192_192
  gray 128_128_128
  white 255_255_255
  maroon 128_0_0
  purple 128_0_128
  fuchsia 255_0_255
  green 0_128_0
  lime 0_255_0
  olive 128_128_0
  yellow 255_255_0
  navy 0_0_128
  blue 0_0_255
  teal 0_128_128
  aqua 0_255_255
  aliceblue 240_248_255
  antiquewhite 250_235_215
  aqua 0_255_255
  aquamarine 127_255_212
  azure 240_255_255
  beige 245_245_220
  bisque 255_228_196
  black 0_0_0
  blanchedalmond 255_235_205
  blueviolet 138_43_226
  brown 165_42_42
  burlywood 222_184_135
  cadetblue 95_158_160
  chartreuse 127_255_0
  chocolate 210_105_30
  coral 255_127_80
  cornflowerblue 100_149_237
  cornsilk 255_248_220
  crimson 220_20_60
  cyan 0_255_255
  darkblue 0_0_139
  darkcyan 0_139_139
  darkgoldenrod 184_134_11
  darkgray 169_169_169
  darkgreen 0_100_0
  darkgrey 169_169_169
  darkkhaki 189_183_107
  darkmagenta 139_0_139
  darkolivegreen 85_107_47
  darkorange 255_140_0
  darkorchid 153_50_204
  darkred 139_0_0
  darksalmon 233_150_122
  darkseagreen 143_188_143
  darkslateblue 72_61_139
  darkslategray 47_79_79
  darkslategrey 47_79_79
  darkturquoise 0_206_209
  darkviolet 148_0_211
  deeppink 255_20_147
  deepskyblue 0_191_255
  dimgray 105_105_105
  dimgrey 105_105_105
  dodgerblue 30_144_255
  firebrick 178_34_34
  floralwhite 255_250_240
  forestgreen 34_139_34
  fuchsia 255_0_255
  gainsboro 220_220_220
  ghostwhite 248_248_255
  gold 255_215_0
  goldenrod 218_165_32
  greenyellow 173_255_47
  grey 128_128_128
  honeydew 240_255_240
  hotpink 255_105_180
  indianred 205_92_92
  indigo 75_0_130
  ivory 255_255_240
  khaki 240_230_140
  lavender 230_230_250
  lavenderblush 255_240_245
  lawngreen 124_252_0
  lemonchiffon 255_250_205
  lightblue 173_216_230
  lightcoral 240_128_128
  lightcyan 224_255_255
  lightgoldenrodyellow 250_250_210
  lightgray 211_211_211
  lightgreen 144_238_144
  lightgrey 211_211_211
  lightpink 255_182_193
  lightsalmon 255_160_122
  lightseagreen 32_178_170
  lightskyblue 135_206_250
  lightslategray 119_136_153
  lightslategrey 119_136_153
  lightsteelblue 176_196_222
  lightyellow 255_255_224
  lime 0_255_0
  limegreen 50_205_50
  linen 250_240_230
  magenta 255_0_255
  maroon 128_0_0
  mediumaquamarine 102_205_170
  mediumblue 0_0_205
  mediumorchid 186_85_211
  mediumpurple 147_112_219
  mediumseagreen 60_179_113
  mediumslateblue 123_104_238
  mediumspringgreen 0_250_154
  mediumturquoise 72_209_204
  mediumvioletred 199_21_133
  midnightblue 25_25_112
  mintcream 245_255_250
  mistyrose 255_228_225
  moccasin 255_228_181
  navajowhite 255_222_173
  navy 0_0_128
  oldlace 253_245_230
  olive 128_128_0
  olivedrab 107_142_35
  orange 255_165_0
  orangered 255_69_0
  orchid 218_112_214
  palegoldenrod 238_232_170
  palegreen 152_251_152
  paleturquoise 175_238_238
  palevioletred 219_112_147
  papayawhip 255_239_213
  peachpuff 255_218_185
  peru 205_133_63
  pink 255_192_203
  plum 221_160_221
  powderblue 176_224_230
  red 255_0_0
  rosybrown 188_143_143
  royalblue 65_105_225
  saddlebrown 139_69_19
  salmon 250_128_114
  sandybrown 244_164_96
  seagreen 46_139_87
  seashell 255_245_238
  sienna 160_82_45
  silver 192_192_192
  skyblue 135_206_235
  slateblue 106_90_205
  slategray 112_128_144
  slategrey 112_128_144
  snow 255_250_250
  springgreen 0_255_127
  steelblue 70_130_180
  tan 210_180_140
  teal 0_128_128
  thistle 216_191_216
  tomato 255_99_71
  turquoise 64_224_208
  violet 238_130_238
  wheat 245_222_179
  whitesmoke 245_245_245
  yellowgreen 154_205_50
);

sub get_extended_colors_hash {
  my %ecolors;
  $ecolors{'normal'} = color('reset');

  foreach my $k (sort keys %colormap) {
    $ecolors{$k} = rgb($fg, split('_', $colormap{$k}));
    $ecolors{"on_" . $k} = rgb($bg, split('_', $colormap{$k}));
  }
  return %ecolors;
}

1;
