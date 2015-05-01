#cs
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

;==>BoostBarracks
Func BoostBarracks()
   If (GUICtrlRead($cmbBoostBarracks) > 0) And ($boostsEnabled = 1)  Then
	  If $barrackPos[0] = "" Then
		LocateBarrack()
		SaveConfig()
		If _Sleep(2000) Then Return
	  EndIf
	  While 1
		 SetLog("Boosting Barracks", $COLOR_BLUE)


			   Click(1, 1)
				 If _Sleep(1000) Then ExitLoop
				 Click($barrackPos[0], $barrackPos[1])
				 If _Sleep(1000) Then ExitLoop
				 _CaptureRegion()
				 $Boost = _PixelSearch(410, 603, 493, 621, Hex(0xfffd70, 6), 10)
				 If IsArray($Boost) Then
					Click($Boost[0], $Boost[1])
					 If _Sleep(1000) Then Return
					 _CaptureRegion()
					 If _ColorCheck(_GetPixelColor(420, 375), Hex(0xd2ec78, 6), 20) Then
						 Click(420, 375)
						 If _Sleep(2000) Then Return
							_CaptureRegion()
						   If _ColorCheck(_GetPixelColor(586, 267), Hex(0xd80405, 6), 20) Then
							  _GUICtrlComboBox_SetCurSel($cmbBoostBarracks, 0)
							  SetLog("Not enough gems", $COLOR_RED)
						   Else
							  _GUICtrlComboBox_SetCurSel($cmbBoostBarracks, (GUICtrlRead($cmbBoostBarracks)-1))
							  SetLog('Boost completed. Remaining :' & (GUICtrlRead($cmbBoostBarracks)), $COLOR_GREEN)
						   EndIf
					 Else
						 SetLog("Barracks are already Boosted", $COLOR_RED)
					 EndIf
					 If _Sleep(500) Then ExitLoop
					 Click(1, 1)
				 Else
					 SetLog("Barracks are already Boosted", $COLOR_RED)
					 If _Sleep(1000) Then Return
				 EndIf

		ExitLoop
	  WEnd
   EndIf


EndFunc ;==>BoostBarracks