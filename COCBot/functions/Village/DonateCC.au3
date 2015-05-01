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

;Donates troops

Func DonateCC($Check = False)
	Global $Donate = $ichkDonateBarbarians = 1 Or $ichkDonateArchers = 1 Or $ichkDonateGiants = 1 Or $ichkDonateAllBarbarians = 1 Or $ichkDonateAllArchers = 1 Or $ichkDonateAllGiants = 1
	If $Donate = False Then Return
	Local $y = 119
	;check for new chats first
	If $Check = True Then
		_CaptureRegion()
		If _ColorCheck(_GetPixelColor(34, 321), Hex(0xE00300, 6), 20) = False And $CommandStop <> 3 Then
			Return ;exit if no new chats
		EndIf
	EndIf


	Click(1, 1) ;Click Away
	_CaptureRegion()
	If _ColorCheck(_GetPixelColor(331, 330), Hex(0xF0A03B, 6), 20) = False Then Click(19, 349) ;Clicks chat thing
	If _Sleep(200) Then Return
	Click(189, 24) ; clicking clan tab

	While $Donate
		If _Sleep(250) Then ExitLoop
		Local $offColors[3][3] = [[0x000000, 0, -2], [0x262926, 0, 1], [0xF8FCF0, 0, 11]]
		Global $DonatePixel = _MultiPixelSearch(202, $y, 203, 670, 1, 1, Hex(0x262926, 6), $offColors, 20)
		If IsArray($DonatePixel) Then
			$Donate = False
			If ($ichkDonateBarbarians = 1 Or $ichkDonateArchers = 1 Or $ichkDonateGiants = 1) Then
				_CaptureRegion(0, 0, 435, $DonatePixel[1] + 50)
				Local $String = getString($DonatePixel[1] - 31)
				If $String = "" Or $String = " " Or $String = "  " Then
					$String = getString($DonatePixel[1] - 17)
				Else
					$String &= @CRLF & getString($DonatePixel[1] - 17)
				EndIf

				SetLog("Chat Request: " & $String)

				If $ichkDonateBarbarians = 1 Then
					Local $Barbs = StringSplit($itxtDonateBarbarians, @CRLF)
					For $i = 0 To UBound($Barbs) - 1
						If CheckDonate($Barbs[$i], $String) Then
							DonateBarbs()
							ExitLoop
						EndIf
					Next
					If $Donate Then
						$y = $DonatePixel[1] + 10
						ContinueLoop
					EndIf
				EndIf
				If $ichkDonateArchers = 1 Then
					Local $Archers = StringSplit($itxtDonateArchers, @CRLF)
					For $i = 0 To UBound($Archers) - 1
						If CheckDonate($Archers[$i], $String) Then
							DonateArchers()
							ExitLoop
						EndIf
					Next
					If $Donate Then
						$y = $DonatePixel[1] + 10
						ContinueLoop
					EndIf
				EndIf
				If $ichkDonateGiants = 1 Then
					Local $Giants = StringSplit($itxtDonateGiants, @CRLF)
					For $i = 0 To UBound($Giants) - 1
						If CheckDonate($Giants[$i], $String) Then
							DonateGiants()
							ExitLoop
						EndIf
					Next
					If $Donate Then
						$y = $DonatePixel[1] + 10
						ContinueLoop
					EndIf
				EndIf
			EndIf
			If ($ichkDonateAllBarbarians = 1 Or $ichkDonateAllArchers = 1 Or $ichkDonateAllGiants = 1) Then
				Select
					Case $ichkDonateAllBarbarians = 1
						DonateBarbs()
					Case $ichkDonateAllArchers = 1
						DonateArchers()
					Case $ichkDonateAllGiants = 1
						DonateGiants()
				EndSelect
			EndIf
			$Donate = True
			$y = $DonatePixel[1] + 10
			Click(1, 1)
			If _Sleep(250) Then ExitLoop
		EndIf
		$DonatePixel = _MultiPixelSearch(202, $y, 203, 670, 1, 1, Hex(0x262926, 6), $offColors, 20)
		If IsArray($DonatePixel) Then ContinueLoop

		Local $Scroll = _PixelSearch(285, 650, 287, 700, Hex(0x97E405, 6), 20)
		$Donate = True
		If IsArray($Scroll) Then
			Click($Scroll[0], $Scroll[1])
			$y = 119
			If _Sleep(250) Then ExitLoop
			ContinueLoop
		EndIf
		$Donate = False
	WEnd

	If _Sleep(300) Then Return
	;SetLog("Finished Donating", $COLOR_GREEN)
	_CaptureRegion()
	If _ColorCheck(_GetPixelColor(331, 330), Hex(0xF0A03B, 6), 20) Then
		Click(331, 330) ;Clicks chat thing
		If _Sleep(250) Then Return
	EndIf

	If GUICtrlRead($gtfo) = 1 Then
		Local $Scroll, $kick_y, $kicked = 0
		While 1
			Click($CCPos[0], $CCPos[1]) ; click clan castle
			If _Sleep(500) Then Return
			Click(530, 600) ; open clan page
			If _Sleep(5000) Then Return ; wait for it to load
			$Scroll = 0
			While 1
				_CaptureRegion(190, 80, 220, 650)
				If _Sleep(1000) Then ExitLoop
				Local $new = _PixelSearch(200, 80, 210, 650, Hex(0xE73838, 6), 20) ; search for red New words
				If IsArray($new) Then
					SetLog("x:" & $new[0] & " y:" & $new[1], $COLOR_RED) ; debuggin purpose
					Click($new[0], $new[1]) ; click the New member
					If _Sleep(500) Then ExitLoop
					If $new[1] + 80 > 640 Then
						$kick_y = 640 ;if the kick button is over bluestack boundary, limit it to the bottom
					Else
						$kick_y = $new[1] + 80 ; else just use it
					EndIf
					Click($new[0] + 300, $kick_y) ; click kick button, hopefully
					If _Sleep(500) Then ExitLoop
					Click(520, 240) ; click Send button
					If _Sleep(500) Then ExitLoop
					$kicked += 1
					SetLog($kicked & " Kicked!", $COLOR_RED)
					If _Sleep(2000) Then ExitLoop
					ExitLoop
				Else
					ControlSend($Title, "", "", "{CTRLDOWN}{UP}{CTRLUP}") ; scroll down the member list
					SetLog("Scrolling down " & $Scroll, $COLOR_RED)
					$Scroll += 1
					If _Sleep(3000) Then ExitLoop
				EndIf
				If $Scroll = 8 Then ExitLoop (2) ; quit the loop if cannot find any New member after scrolling 8 times
			WEnd
		WEnd
		SetLog("Finished kicking", $COLOR_RED)
	EndIf
	ClickP($TopLeftClient)
EndFunc   ;==>DonateCC

Func CheckDonate($String, $clanString) ;Checks if it exact
	$Contains = StringMid($String, 1, 1) & StringMid($String, StringLen($String), 1)
	If $Contains = "[]" Then
		If $clanString = StringMid($String, 2, StringLen($String) - 2) Then
			Return True
		Else
			Return False
		EndIf
	Else
		If StringInStr($clanString, $String, 2) Then
			Return True
		Else
			Return False
		EndIf
	EndIf
EndFunc   ;==>CheckDonate

Func DonateBarbs()
	If $ichkDonateBarbarians = 1 Or $ichkDonateAllBarbarians = 1 Then
		Click($DonatePixel[0], $DonatePixel[1] + 11)
		If _Sleep(1000) Then Return
		_CaptureRegion(0, 0, 517, $DonatePixel[1] + 50)
		If _ColorCheck(_GetPixelColor(237, $DonatePixel[1] - 5), Hex(0x507C00, 6), 10) Or _ColorCheck(_GetPixelColor(237, $DonatePixel[1] - 10), Hex(0x507C00, 6), 10) Then
			$MaxDonations = GUICtrlRead($cmbMaxDonations)
			SetLog("Donating Barbarians", $COLOR_GREEN)
			If _Sleep(250) Then Return
			Click(237, $DonatePixel[1] - 5, $MaxDonations, 50)
			$CurBarb += $MaxDonations
			$ArmyComp -= $MaxDonations
			$Donate = True
		ElseIf $ichkDonateAllArchers = 1 Then
			DonateArchers()
			Return
		Else
			SetLog("No Barbarians available to donate..", $COLOR_RED)
			Return
		EndIf
		If _Sleep(250) Then Return
		Click(1, 1)
		If _Sleep(250) Then Return
	Else
		DonateArchers()
		Return
	EndIf
EndFunc   ;==>DonateBarbs

Func DonateArchers()
	If $ichkDonateArchers = 1 Or $ichkDonateAllArchers = 1 Then
		Click($DonatePixel[0], $DonatePixel[1] + 11)
		If _Sleep(1000) Then Return
		_CaptureRegion(0, 0, 517, $DonatePixel[1] + 50)
		If _ColorCheck(_GetPixelColor(315, $DonatePixel[1] - 5), Hex(0x507C00, 6), 10) Or _ColorCheck(_GetPixelColor(315, $DonatePixel[1] - 10), Hex(0x507C00, 6), 10) Then
			$MaxDonations = GUICtrlRead($cmbMaxDonations)
			SetLog("Donating  Archers", $COLOR_GREEN)
			If _Sleep(250) Then Return
			Click(315, $DonatePixel[1] - 5, $MaxDonations, 50)
			$CurArch += $MaxDonations
			$ArmyComp -= $MaxDonations
			$Donate = True
		ElseIf $ichkDonateAllGiants = 1 Then
			DonateGiants()
			Return
		Else
			SetLog("No Archers available to donate..", $COLOR_RED)
			Return
		EndIf
		If _Sleep(250) Then Return
		Click(1, 1)
		If _Sleep(250) Then Return
	Else
		DonateGiants()
		Return
	EndIf
EndFunc   ;==>DonateArchers

Func DonateGiants()
	If $ichkDonateGiants = 1 Or $ichkDonateAllGiants = 1 Then
		Click($DonatePixel[0], $DonatePixel[1] + 11)
		If _Sleep(1000) Then Return
		_CaptureRegion(0, 0, 517, $DonatePixel[1] + 50)
		If _ColorCheck(_GetPixelColor(397, $DonatePixel[1] - 5), Hex(0x507C00, 6), 10) Or _ColorCheck(_GetPixelColor(480, $DonatePixel[1] - 10), Hex(0x507C00, 6), 10) Then ; quick fix by promac from gamebot.org
			$MaxDonations = GUICtrlRead($cmbMaxDonations)
			SetLog("Donating Giants", $COLOR_GREEN)
			If _Sleep(250) = True Then Return
			Click(397, $DonatePixel[1] - 5, $MaxDonations, 50)
			$CurGiant += $MaxDonations
			$ArmyComp -= $MaxDonations * 5
			$Donate = True
		Else
			SetLog("No Giants available to donate..", $COLOR_RED)
		EndIf
		If _Sleep(250) Then Return
		Click(1, 1)
		If _Sleep(250) Then Return
	Else
		SetLog("No troops available to donate..", $COLOR_RED)
		If _Sleep(250) Then Return
	EndIf
EndFunc   ;==>DonateGiants
