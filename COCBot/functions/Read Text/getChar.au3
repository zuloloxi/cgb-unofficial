﻿#cs
This file is part of ClashGameBot.

ClashGameBot is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

ClashGameBot is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with ClashGameBot.  If not, see <http://www.gnu.org/licenses/>.
#ce
;==============================================================================================================

;===Get Char===================================================================================================
;--------------------------------------------------------------------------------------------------------------
;Finds pixel color pattern of specific X and Y values, returns char if pixel color pattern found.
;--------------------------------------------------------------------------------------------------------------

Func getChar(ByRef $x, $y)
	Local $charWidth[54] = [2, _						;{space}
							7,5,7,6,6,5,6,6,6,6, _		;Aa Bb Cc Dd Ee
							5,5,6,5,8,6,2,2,6,3, _		;Ff Gg Hh Ii Jj
							7,5,4,2,10,10,7,6,6,6, _	;Kk Ll Mm Nn Oo
							6,5,7,6,7,5,7,6,6,6, _		;Pp Qq Rr Ss Tt
							7,6,7,6,11,9,7,6,7,6, _		;Uu Vv Ww Xx Yy
							7,4,2]						;Zz ,

	Local $charString[54] = [" ", _
							"A", "a", "B", "b", "C", "c", "D", "d", "E", "e", _
							"F", "f", "G", "g", "H", "h", "I", "i", "J", "j", _
							"K", "k", "L", "l", "M", "m", "N", "n", "O", "o", _
							"P", "p", "Q", "q", "R", "r", "S", "s", "T", "t", _
							"U", "u", "V", "v", "W", "w", "X", "x", "Y", "y", _
							"Z", "z", ","]

	Local $charOffset[54][3][2] = [[[1,3], [1,7], [2,5]], _																						;{space}
 [[1,8], [5,7], [6,8]], [[5,3], [1,4], [4,7]], [[6,1], [1,1], [3,4]], [[3,4], [4,7], [1,1]], [[1,1], [2,2], [5,3]], [[3,2], [5,8], [4,4]], _ 	;Aa Bb Cc
 [[3,7], [6,1], [2,3]], [[3,4], [4,7], [1,3]], [[2,6], [2,2], [3,0]], [[1,2], [2,3], [4,6]], [[3,2], [1,8], [5,1]], [[5,1], [2,4], [2,8]], _	;Dd Ee Ff
 [[4,4], [3,0], [4,5]], [[1,9], [4,8], [4,4]], [[5,8], [3,3], [1,1]], [[2,5], [3,4], [5,3]], [[1,2], [2,5], [1,8]], [[1,1], [1,2], [1,8]], _	;Gg Hh Ii
 [[1,5], [4,7], [6,1]], [[1,0], [1,4], [1,9]], [[2,3], [3,6], [6,0]], [[1,1], [2,1], [4,8]], [[2,7], [4,7], [1,0]], [[1,2], [0,2], [1,7]], _	;Jj Kk Ll
 [[4,8], [6,1], [8,8]], [[1,8], [7,2], [5,4]], [[3,1], [5,4], [6,1]], [[5,3], [4,8], [2,5]], [[2,6], [2,0], [5,6]], [[2,4], [4,5], [3,2]], _	;Mm Nn Oo
 [[4,2], [2,8], [5,3]], [[2,4], [1,10],[5,3]], [[4,9], [2,2], [6,4]], [[3,4], [4,8], [4,10]],[[4,2], [3,6], [6,1]], [[4,5], [2,6], [2,2]], _	;Pp Qq Rr
 [[2,0], [5,4], [3,7]], [[2,2], [4,4], [2,7]], [[1,0], [4,2], [2,8]], [[2,1], [1,8], [4,6]], [[1,1], [1,8], [5,1]], [[2,3], [2,7], [4,3]], _	;Ss Tt Uu
 [[2,2], [3,5], [5,7]], [[2,3], [3,6], [5,3]], [[2,3], [6,1], [9,8]], [[3,5], [5,7], [8,8]], [[1,2], [3,7], [5,4]], [[1,4], [2,8], [5,6]], _	;Vv Ww Xx
 [[2,1], [5,5], [3,8]], [[1,8], [3,7], [3,10]],[[2,2], [1,7], [5,7]], [[1,4], [3,5], [2,8]], [[1,7], [1,8], [1,9]]]								;Yy Zz ,

	Local $charColor[54][3] = [[0x3F4440,0x3F4440,0x3F4440], _																														;{space}
 [0xE7E7E7,0xDBDCDB,0xD5D6D5],[0xACAEAC,0xC2C3C2,0xDADBDA],[0xE2E3E2,0xFBFBFA,0xE8E9E8],[0x8D8F8D,0xCACBCA,0xFBFBFB],[0xE8E8E8,0xC9CAC9,0xDBDBDB],[0x818481,0x949694,0xECEDEC], _	;Aa Bb Cc
 [0xACAEAC,0xA0A2A0,0xB6B8B6],[0x8D8F8D,0xE4E5E4,0xABADAB],[0xA5A7A5,0xC3C5C3,0x767976],[0x404440,0xF5F5F5,0x7B7D7B],[0x515451,0xE1E1E1,0xC6C7C6],[0xC4C5C4,0xBFC0BF,0x535653], _	;Dd Ee Ff
 [0x707370,0xC4C5C4,0xD1D2D1],[0xD7D7D7,0xE6E6E6,0xE7E7E7],[0x5F635F,0x464A46,0xFAFAFA],[0x818481,0xD3D4D3,0x646764],[0xFEFEFE,0xA3A5A3,0xE1E1E1],[0xF0F1F0,0x454945,0xE1E1E1], _	;Gg Hh Ii
 [0x8E908E,0xC4C5C4,0xFBFBFB],[0x9CA19D,0xF9F9F9,0xF9F9F9],[0xCFD0CF,0x828482,0x7C7E7C],[0xFBFBFB,0x646764,0xDBDCDB],[0xFDFDFD,0x828482,0x646764],[0xFEFEFE,0x909290,0xFEFEFE], _	;Jj Kk Ll
 [0x8C8E8C,0x6A6D6A,0xA9ABA9],[0xD5D6D5,0x585C58,0xFFFFFF],[0x949694,0x707370,0xBFC0BF],[0xBEC0BE,0x8A8D8A,0x7A7D7A],[0xBBBDBB,0x888A88,0xD9DAD9],[0x888A88,0xA9ABA9,0x585C58], _	;Mm Nn Oo
 [0x636663,0x858785,0xE6E7E6],[0x8D908D,0xFFFFFF,0x898B89],[0xE6E7E6,0xABADAB,0xFFFFFF],[0x696C69,0xFFFFFF,0xC1C2C1],[0x575A57,0x939593,0xB8BAB8],[0x747774,0x5F635F,0x464A46], _	;Pp Qq Rr
 [0x8E908E,0x9C9E9C,0x7C7F7C],[0x707370,0xC3C4C3,0x909290],[0x707370,0xB7B8B7,0x969896],[0x767976,0xB6B8B6,0xA6A8A6],[0xFBFBFB,0x626562,0xBFC0BF],[0x525652,0xCBCCCB,0x888A88], _	;Ss Tt Uu
 [0x898C89,0x707370,0xE1E2E1],[0x595C59,0x525652,0xEEEEEE],[0xAEB0AE,0xC5C6C5,0x989A98],[0x8E918E,0x747674,0x797C79],[0x989B98,0x939593,0xB6B8B6],[0x8C8E8C,0x9EA09E,0x4C4F4C], _	;Vv Ww Xx
 [0xA1A3A1,0x8C8E8C,0xD5D6D5],[0x5D615D,0xEEEEEE,0xE8E9E8],[0x505450,0x707370,0x888B88],[0x757775,0x757875,0xDADBDA],[0xE8E8E8,0xFEFEFE,0xA5A7A5]]									;Yy Zz ,

	For $i = 0 to 53
		For $z = -1 to 4
			Local $pixel1[3] = [$x + $z + $charOffset[$i][0][0], $y + $charOffset[$i][0][1], Hex($charColor[$i][0], 6)]
			Local $pixel2[3] = [$x + $z + $charOffset[$i][1][0], $y + $charOffset[$i][1][1], Hex($charColor[$i][1], 6)]
			Local $pixel3[3] = [$x + $z + $charOffset[$i][2][0], $y + $charOffset[$i][2][1], Hex($charColor[$i][2], 6)]
			If boolPixelSearch($pixel1, $pixel2, $pixel3, 1) Then
				$x += $z + $charWidth[$i]
				Return $charString[$i]
			EndIf
		Next
	Next
	Local $Charset_Rus[43][4][3] = [ _
 [[2,3,0xA2A4A2], [5,8,0xF6F7F6], [2,4,0xA4A5A4],[8,"ю",0]], _; ю
 [[8,3,0xDDDEDD], [9,8,0x414541], [3,4,0x707370],[10,"ы",0]], _; ы
 [[2,2,0x515551], [7,9,0x454945], [7,3,0xA1A3A1],[11,"щ",0]], _; щ
 [[6,2,0x5E615E], [2,8,0xFBFCFB], [2,3,0x414541],[8,"ш",0]], _; ш
 [[5,9,0x424642], [2,2,0x525552], [5,8,0x949694],[7,"р",0]], _; р
 [[4,0,0xFAFAFA], [1,1,0x434643], [3,2,0x434743],[5,"й",0]], _; й
 [[3,2,0x696C69], [8,8,0xE3E4E3], [2,3,0x414541],[9,"ж",0]], _; ж
 [[1,10,0xE1E1E1], [4,9,0x454945], [5,8,0xFFFFFF],[7,"д",0]], _; д
 [[5,9,0x454945], [2,2,0x828482], [4,8,0xDBDCDB],[5,"а",0]], _; а
 [[2,2,0xABADAB], [2,8,0xF7F7F7], [2,3,0xC1C3C1],[5,"б",0]], _; б
 [[4,2,0x646764], [1,3,0xFCFCFC], [3,8,0xFBFBFB],[6,"в",0]], _; в
 [[3,9,0x515451], [1,8,0x8D8F8D], [1,4,0xFDFDFD],[7,"е",0]], _; е
 [[5,0,0x7C7F7C], [3,9,0x515451], [5,2,0x414541],[5,"ё",0]], _; ё
 [[3,9,0x444844], [1,2,0x888A88], [4,8,0x636663],[5,"з",0]], _; з
 [[4,8,0xFFFFFF], [0,3,0xFBFBFB], [2,7,0x5C605C],[5,"и",0]], _; и
 [[2,8,0x434743], [1,3,0x9B9D9B], [1,7,0x9FA19F],[5,"к",0]], _; к
 [[2,3,0xFBFBFB], [4,8,0xFEFEFE], [3,4,0xA7A9A7],[9,"м",0]], _; м
 [[1,2,0x525552], [0,3,0xFBFBFB], [1,7,0x868886],[5,"н",0]], _; н
 [[1,9,0x424642], [3,2,0x888A88], [3,8,0xFBFBFB],[5,"о",0]], _; о
 [[2,2,0x828482], [1,8,0xFFFFFF], [4,3,0xFCFCFC],[6,"п",0]], _; п
 [[4,9,0x454945], [1,3,0xD5D6D5], [4,8,0xE7E7E7],[6,"с",0]], _; с
 [[5,2,0x828482], [2,3,0xFCFCFC], [2,8,0xCDCFCD],[6,"т",0]], _; т
 [[4,2,0x707370], [3,3,0x464A46], [3,7,0xFEFEFE],[5,"у",0]], _; у
 [[4,1,0xFFFFFF], [5,10,0x6B6F6B], [3,2,0xC0C2C0],[9,"ф",0]], _; ф
 [[1,2,0x818481], [5,8,0xCACCCA], [2,3,0x9A9C9A],[6,"х",0]], _; х
 [[4,2,0x646764], [5,9,0xBDBEBD], [1,3,0xFBFBFB],[8,"ц",0]], _; ц
 [[1,2,0x818481], [2,4,0x7E817E], [5,7,0xFFFFFF],[6,"ч",0]], _; ч
 [[1,2,0x818481], [2,8,0xFEFEFE], [5,4,0x828482],[8,"ъ",0]], _; ъ
 [[2,2,0x5E615E], [1,3,0xFBFBFB], [3,8,0xFBFCFB],[6,"ь",0]], _; ь
 [[1,3,0xEDEEED], [3,8,0xFCFCFC], [0,4,0x949694],[7,"э",0]], _; э
 [[0,8,0xFEFEFE], [0,3,0xE1E2E1], [0,7,0xDEDFDE],[5,"я",0]], _; я
 [[0,3,0xB7B8B7], [1,8,0xCFD0CF], [1,6,0xFFFFFF],[2,"1",0]], _; 1
 [[2,0,0xA0A2A0], [5,2,0xF8F9F8], [2,8,0xCFD0CF],[5,"2",0]], _; 2
 [[6,0,0x414541], [6,1,0xBEC0BE], [0,2,0x949694],[5,"3",0]], _; 3
 [[4,0,0x646764], [4,1,0xFBFBFB], [1,2,0x4C4F4C],[5,"4",0]], _; 4
 [[3,0,0x6A6D6A], [5,1,0xBFC1BF], [3,9,0x454945],[6,"5",0]], _; 5
 [[3,1,0xBCBDBC], [6,2,0xADAFAD], [0,7,0x606360],[5,"6",0]], _; 6
 [[1,7,0xF6F7F6], [4,3,0x424642], [3,5,0x7A7C7A],[5,"7",0]], _; 7
 [[6,0,0x4C504C], [1,1,0xFAFAFA], [5,9,0x444844],[5,"8",0]], _; 8
 [[4,0,0xC4C5C4], [4,1,0xE5E6E5], [3,2,0x444744],[5,"9",0]], _; 9
 [[3,0,0xACAEAC], [2,1,0xDFE0DF], [3,9,0x454945],[6,"0",0]], _; 0
 [[2,2,0x828482], [0,3,0xFBFBFB], [1,6,0x848684],[5,"г",0]], _; г
 [[2,3,0xFBFBFB], [5,8,0xFEFEFE], [4,4,0xB0B2B0],[7,"л",0]]]  ; л

	For $i = 0 to 42
		For $z = -1 to 4
			Local $pixel1[3] = [$x + $z + $Charset_Rus[$i][0][0], $y + $Charset_Rus[$i][0][1], Hex($Charset_Rus[$i][0][2], 6)]
			Local $pixel2[3] = [$x + $z + $Charset_Rus[$i][1][0], $y + $Charset_Rus[$i][1][1], Hex($Charset_Rus[$i][1][2], 6)]
			Local $pixel3[3] = [$x + $z + $Charset_Rus[$i][2][0], $y + $Charset_Rus[$i][2][1], Hex($Charset_Rus[$i][2][2], 6)]
			If boolPixelSearch($pixel1, $pixel2, $pixel3, 1) Then
				$x += $z + $Charset_Rus[$i][3][0]
				Return $Charset_Rus[$i][3][1]
			EndIf
		Next
	Next
	Return "|"
EndFunc
