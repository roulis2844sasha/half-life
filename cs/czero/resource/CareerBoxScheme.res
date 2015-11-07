//
// TRACKER SCHEME RESOURCE FILE
//
// sections:
//		colors			- all the colors used by the scheme
//		basesettings	- contains settings for app to use to draw controls
//		fonts			- list of all the fonts used by app
//		borders			- description of all the borders
//
// notes:
// 		hit ctrl-alt-shift-R in the app to reload this file
//
Scheme
{
	//Name - currently overriden in code
	//{
	//	"Name"	"CareerScheme"
	//}

	//////////////////////// COLORS ///////////////////////////
	Colors
	{
		// base colors
		"BaseText"			"189 189 189 255"	// used in text windows, lists
		"BrightBaseText"		"255 255 255 255"	// brightest text
		"SelectedText"		"255 242 45 255"	// selected text
		"DimBaseText"		"255 242 45 255"	// dim base text
		"LabelDimText"		"255 176 0 164"	// used for info text
		"ControlText"		"255 255 255 255"	// used in all text controls
		//"BrightControlText"	"255 242 45 255"	// use for selected controls
		//"BrightControlText"	"28 207 61 255"	// use for selected controls
		"BrightControlText"	"255 255 255 255"	// use for selected controls
		"DisabledText1"		"80 48 0 255"	// disabled text
		"DisabledText2"		"0 0 0 0"		// overlay color for disabled text (to give that inset look)
		"DimListText"		"188 112 0 255"	// offline friends, unsubscribed games, etc.

		// background colors
		"ControlBG"			"0 0 0 0"		// background color of controls
		"ControlDarkBG"		"74 74 74 255"		// darker background color; used for background of scrollbars
		"WindowBG"			"60 60 60 255"		// background color of text edit panes (chat, text entries, etc.)
		"SelectionBG"		"88 88 88 0"		// background color of any selected text or menu item
		"SelectionBG2"		"88 88 88 0"		// selection background in window w/o focus
		"ListBG"			"0 0 0 128"		// background of scoreboard
		"ViewportBG"		"0 0 0 200"
		"Menu/BgColor"		"60 60 60 255"
		"CareerButtonBG"	"0 0 0 0"

		"WindowTitleBG"		"100 100 100 255"	// background color of stripe across screen underneath title text

		"AutosaveNoticeLabelBG"	"0 0 0 192"
		"CareerBoxBG"			"0 0 0 192"

		"ProfileButtonBG"	"0 0 0 0"

		//"ProfileButtonActiveBG"	"255 176 0 127"		// Orange BG, green text
		//"ProfileButtonFG"		"28 207 61 255"

		"ProfileButtonActiveBG"	"0 192 0 127"			// Green BG, white text
		"ProfileButtonFG"		"255 255 255 255"

		// Map select button colors
		"MapActiveBG"			"255 255 255 255"		// background color of the active map in the map select panel
		"MapDisabledBG"		" 64  64  64 255"		// background color of a disabled map in the map select panel
		"MapArmedBG"			"255 255 255 255"		// background color of the armed map in the map select panel
		"MapDepressedBG"	"255 255   0 255"		// background color of the depressed map in the map select panel
		"MapInactiveBG"		"200 200 200 255"		// background color of any other unbeaten map in the map select panel
		"MapDefeatedBG"		"200 200 200 255"		// background color of any other defeated map in the map select panel

		"PlayerName"		"28 207 61 255"			// player name on map screen
		"ActiveTriplet"		"28 207 61 255"			// green border around triplet
		"SelectedMap"		"255 242 0 255"			// yellow border around selected map
		"MapText"		"255 242 0 255"			// map title and description

		"UnlockedTriplet"	"189 189 189 255"		// color of "UNLOCKED" text above triplet
		"CurrentTriplet"	"189 189 189 255"		// color of "CURRENT" text above triplet
		"LockedTriplet"		"189 0 0 255"			// color of "LOCKED" text above triplet
		"TourOfDuty"		"255 255 255 255"		// color of "Tour of Duty N" text above triplet

		// Bot roster button colors
		"BotDisabledBG"		"64 64 64 192"		// background color of a disabled bot images
		"BotArmedBG"		"255 255 255 255"	// background color of the armed bot button images
		"BotDepressedBG"	"255 255 255 255"	// background color of the depressed bot button images
		"BotNormalBG"		"255 255 255 255"	// background color of any other bot images

		// Text colors for bot roster buttons
		"BotPoints"			"255 255 255 255"
		"BotName"			"255 255 255 255"
		"BotDesc"			"255 255 255 255"	// Skill:, Co-Op:, Bravery: labels
		//"BotRange0"			"204  51  51 255"
		//"BotRange1"			"204 153   0 255"
		//"BotRange2"			"204 204 204 255"
		//"BotRange3"			"204 204   0 255"
		//"BotRange4"			" 51 204  51 255"
		"BotRange0"			"255   0   0 255"
		"BotRange1"			"255 100   0 255"
		"BotRange2"			"255 255   0 255"
		"BotRange3"			"  0 180   0 255"
		"BotRange4"			" 50 255  50 255"
		
		// Bg colors for bot roster buttons
		"BotBg0"			"64 64 64 255"
		"BotBg1"			"100 100 100 255"
		"BotBg2"			"64 64 64 255"
		"BotBg3"			"100 100 100 255"
		"BotBg4"			"64 64 64 255"
		"BotBg5"			"100 100 100 255"
		"BotBgDisabled"			"0 0 0 100"
		"BotTextDisabled"		"88 88 88 255"

		// titlebar colors
		"TitleText"			"255 174 0 255"
		"TitleDimText"		"255 174 0 255"
		"TitleBG"			"255 255 0 0"
		"TitleDimBG"		"255 255 0 0"
		
		// slider tick colors
		"SliderTickColor"		"127 140 127 255"
		"SliderTrackColor"	"31 31 31 255"

		// border colors
		//"BorderBright"		"188 112 0 128"	// the lit side of a control
		//"BorderDark"		"188 112 0 128"	// the dark/unlit side of a control
		//"BorderSelection"		"188 112 0 0"	// the additional border color for displaying the default/selected button
		"BorderBright"		"189 189 189 255"	// the lit side of a control
		"BorderDark"		"189 189 189 255"	// the dark/unlit side of a control
		"BorderSelection"		"189 189 189 255"	// the additional border color for displaying the default/selected button

		"ButtonBorder"			"189 189 189 255"
		"ButtonBorderDark"		"189 189 189 255"
		"ButtonBorderArmed"		"255 242 0 255"
		"ButtonBorderArmedDark"		"255 242 0 255"
		"ButtonBorderDepressed"		"255 242 0 255"
		"ButtonBorderDepressedDark"	"255 242 0 255"

		"ButtonDepressedBorderBright"	"255 242 0 255"
		"ButtonDepressedBorderDark"	"255 242 0 255"

		"team0"			"204 204 204 255" // Spectators
		"team1"			"255 64 64 255" // CT's
		"team2"			"153 204 255 255" // T's

		"MapDescriptionText"	"255 242 45 255" // the text used in the map description window

		"MissionPackURL"	"255 242 45 255"
		"MissionPackNonURL"	"189 189 189 255"
	}

	///////////////////// BASE SETTINGS ////////////////////////
	// default settings for all panels
	// controls use these to determine their settings
	BaseSettings
	{
		"JumpButtonFlashPeriod"		"0.2"
		"JumpButtonNumFlashes"		"30"

		// Fonts for bot roster buttons
		"BotPointsFont"		"BotPoints"
		"BotNameFont"		"BotName"
		
		"BotCategoryFont"	"DefaultBold"
		"BotRange0Font"		"DefaultBold"
		"BotRange1Font"		"DefaultBold"
		"BotRange2Font"		"DefaultBold"
		"BotRange3Font"		"DefaultBold"
		"BotRange4Font"		"DefaultBold"
		
		"CareerButtonTextPad"	"6"
		"CareerButtonImagePad"	"4"

		"FgColor"			"ControlText"
		"BgColor"			"WindowBG"
		"LabelBgColor"		"ControlBG"
		"SubPanelBgColor"	"ControlBG"

		"DisabledFgColor1"		"DisabledText1" 
		"DisabledFgColor2"		"DisabledText2"			// set this to the BgColor if you don't want it to draw

		"TitleBarFgColor"			"TitleText"
		"TitleBarDisabledFgColor"	"TitleDimText"
		"TitleBarBgColor"			"TitleBG"
		"TitleBarDisabledBgColor"	"TitleDimBG"

		"TitleBarIcon"				"resource/icon_steam"
		"TitleBarDisabledIcon"		"resource/icon_steam_disabled"

		"TitleButtonFgColor"			"BorderBright"
		"TitleButtonBgColor"			"ControlBG"
		"TitleButtonDisabledFgColor"	"TitleDimText"
		"TitleButtonDisabledBgColor"	"TitleDimBG"

		"TextCursorColor"			"BaseText"			// color of the blinking text cursor in text entries
		"URLTextColor"				"BrightBaseText"	// color that URL's show up in chat window

		Menu
		{
			"FgColor"			"DimBaseText"
			"BgColor"			"ControlBG"
			"ArmedFgColor"		"BrightBaseText"
			"ArmedBgColor"		"SelectionBG"
			"DividerColor"		"BorderDark"
			"TextInset"			"6"
		}

		MenuButton	  // the little arrow on the side of boxes that triggers drop down menus
		{
			"ButtonArrowColor"	"DimBaseText"		// color of arrows
		   	"ButtonBgColor"		"WindowBG"			// bg color of button. same as background color of text edit panes 
			"ArmedArrowColor"	"BrightBaseText"	// color of arrow when mouse is over button
			"ArmedBgColor"		"DimBaseText"		// bg color of button when mouse is over button
		}

		Slider
		{
			"SliderFgColor"		"ControlDarkBG"			// handle with which the slider is grabbed
			"SliderBgColor"		"ControlBG"		// area behind handle
		}

		ScrollBarSlider
		{
			"BgColor"					"ControlBG"		// this isn't really used
			"ScrollBarSliderFgColor"	"WindowTitleBG"		// handle with which the slider is grabbed
			"ScrollBarSliderBgColor"	"WindowBG"	// area behind handle
			"ButtonFgColor"				"ControlDarkBG"	// color of arrows
		}


		// text edit windows
		"WindowFgColor"				"BaseText"		// off-white
		"WindowBgColor"				"WindowBG"		// redundant. can we get rid of WindowBgColor and just use WindowBG?
		"WindowDisabledFgColor"		"DimBaseText"
		"WindowDisabledBgColor"		"ListBG"		// background of chat conversation
		"SelectionFgColor"			"SelectedText"	// fg color of selected text
		"SelectionBgColor"			"SelectionBG"
		"ListSelectionFgColor"		"SelectedText"
		"ListBgColor"				"ListBG"		// background of server browser control, etc
		"BuddyListBgColor"			"ListBG"		// background of buddy list pane
		
		// App-specific stuff
		"ChatBgColor"				"WindowBG"

		// status selection
		"StatusSelectFgColor"		"BrightBaseText"
		"StatusSelectFgColor2"		"BrightControlText"	// this is the color of the friends status

		// checkboxes
		"CheckButtonBorder1"   		"BorderDark"		// the left checkbutton border
		"CheckButtonBorder2"   		"BorderBright"		// the right checkbutton border
		"CheckButtonCheck"			"BrightControlText"	// color of the check itself
		"CheckBgColor"				"ListBG"

		// buttons (default fg/bg colors are used if these are not set)
//		"ButtonArmedFgColor"
		"ButtonArmedBgColor"		"SelectionBG"
//		"ButtonDepressedFgColor"	"BrightControlText"
		"ButtonDepressedBgColor"	"SelectionBG2"

		// buddy buttons
		BuddyButton
		{
			"FgColor1"				"ControlText"
			"FgColor2"				"DimListText"
			"ArmedFgColor1"			"BrightBaseText"
			"ArmedFgColor2"			"BrightBaseText"
			"ArmedBgColor"			"SelectionBG"
		}

		Chat
		{
			"TextColor"				"BrightControlText"
			"SelfTextColor"			"BaseText"
			"SeperatorTextColor"	"DimBaseText"
		}

		"SectionTextColor"		"BrightControlText"	// text color for IN-GAME, ONLINE, OFFLINE sections of buddy list
		"SectionDividerColor"	"BorderDark"		// color of line that runs under section name in buddy list
	}

	//
	//////////////////////// FONTS /////////////////////////////
	//
	// describes all the fonts
	Fonts
	{
		// fonts are used in order that they are listed
		// fonts listed later in the order will only be used if they fulfill a range not already filled
		// if a font fails to load then the subsequent fonts will replace
		"Default"
		{
			"1"
			{
				"name"		"Tahoma"
				"tall"		"11"
				"weight"	"500"
			}
		}
		"DefaultShadow"
		{
			"1"
			{
				"name"		"Tahoma"
				"tall"		"11"
				"weight"	"500"
				"dropshadow"	"1"
			}
		}
		"DefaultBold"
		{
			"1"
			{
				"name"		"Tahoma"
				"tall"		"11"
				"weight"	"700"
			}
		}
		"DialogTitle"
		{
			"1"
			{
				"name"		"Tahoma"
				"tall"		"14"
				"weight"	"500"
			}
		}
		"MapComplete"
		{
			"1"
			{
				"name"		"Tahoma"
				"tall"		"12"
				"weight"	"800"
				"dropshadow"	"1"
			}
		}
		"DefaultNonCareer"
		{
			"1"
			{
				"name"		"Verdana"
				"tall"		"12"
				"weight"	"600"
				"yres"	"480 599"
			}
			"2"
			{
				"name"		"Verdana"
				"tall"		"13"
				"weight"	"600"
				"yres"	"600 767"
			}
			"3"
			{
				"name"		"Verdana"
				"tall"		"14"
				"weight"	"600"
				"yres"	"768 1023"
				"antialias"	"1"
			}
			"4"
			{
				"name"		"Verdana"
				"tall"		"20"
				"weight"	"600"
				"yres"	"1024 1199"
				"antialias"	"1"
			}
			"5"
			{
				"name"		"Verdana"
				"tall"		"24"
				"weight"	"600"
				"yres"	"1200 6000"
				"antialias"	"1"
			}
		}
		"MapName"
		{
			"1"
			{
				"name"		"Tahoma"
				"tall"		"16"
				"weight"	"1000"
				"dropshadow"	"1"
			}
		}
		"MapDescription"
		{
			"1"
			{
				"name"		"Tahoma"
				"tall"		"11"
				"weight"	"0"
				"yres"	"480 599"
			}
			"2"
			{
				"name"		"Tahoma"
				"tall"		"10"
				"weight"	"0"
			}
		}
		"DottedBoxCaption"
		{
			"1"
			{
				"name"		"Verdana"
				"tall"		"12"
				"weight"	"0"
				"yres"	"480 599"
			}
			"2"
			{
				"name"		"Verdana"
				"tall"		"13"
				"weight"	"0"
				"yres"	"600 767"
			}
			"3"
			{
				"name"		"Verdana"
				"tall"		"14"
				"weight"	"0"
				"yres"	"768 1023"
				"antialias"	"1"
			}
			"4"
			{
				"name"		"Verdana"
				"tall"		"20"
				"weight"	"0"
				"yres"	"1024 1199"
				"antialias"	"1"
			}
			"5"
			{
				"name"		"Verdana"
				"tall"		"24"
				"weight"	"0"
				"yres"	"1200 6000"
				"antialias"	"1"
			}
		}
		"BotPoints"
		{
			"1"
			{
				"name"		"Tahoma"
				"tall"		"14"
				"weight"		"800"
				"antialias"	"1"
			}
		}
		"BotName"
		{
			"1"
			{
				"name"		"Tahoma"
				"tall"		"12"
				"weight"		"800"
				"antialias"	"1"
			}
		}
		"Medium"
		{
			"1"
			{
				"name"		"Tahoma"
				"tall"		"16"
				"weight"		"800"
				"antialias"	"1"
			}
//			"1"
//			{
//				"name"		"Verdana"
//				"tall"		"16"
//				"weight"	"600"
//				"yres"	"1024 1199"
//				"antialias"	"1"
//			}
		}
		"MediumItalic"
		{
			"1"
			{
				"name"		"Tahoma"
				"tall"		"16"
				"weight"		"800"
				"antialias"	"1"
				"italic"	"1"
				"dropshadow" "1"
			}
//			"1"
//			{
//				"name"		"Verdana"
//				"tall"		"16"
//				"weight"	"600"
//				"yres"	"1024 1199"
//				"antialias"	"1"
//				"italic"	"1"
//				"dropshadow" "1"
//			}
		}
		"Large"
		{
			"1"
			{
				"name"		"Tahoma"
				"tall"		"20"
				"weight"	"800"
				"yres"	"1024 1199"
				"antialias"	"1"
			}
		}
		"Title"
		{
			"1"
			{
				"name"		"Tahoma"
				"tall"		"24"
				"weight"		"800"
			}
		}
		"TitleOld"
		{
			"1"
			{
				"name"		"Verdana"
				"tall"		"30"
				"weight"	"600"
				"yres"	"1024 1199"
				"antialias"	"1"
			}
			"2"
			{
				"name"		"Arial"
				"tall"		"33"
				"weight"		"800"
			}
		}
		"Huge"
		{
			"1"
			{
				"name"		"Verdana"
				"tall"		"40"
				"weight"	"600"
				"yres"	"1024 1199"
				"antialias"	"1"
			}
			"2"
			{
				"name"		"Arial"
				"tall"		"44"
				"weight"		"800"
			}
		}
		"Points"
		{
			"1"
			{
				"name"		"Tahoma"
				"tall"		"48"
				"weight"	"0"
				"antialias"	"1"
			}
		}
		"DefaultUnderline"
		{
			"1"
			{
				"name"		"Tahoma"
				"tall"		"12"
				"weight"	"500"
				"underline" "1"
			}
		}
		"DefaultSmall"
		{
			"1"
			{
				"name"		"Verdana"
				"tall"		"12"
				"weight"	"0"
				"yres"	"480 599"
			}
			"2"
			{
				"name"		"Verdana"
				"tall"		"13"
				"weight"	"0"
				"yres"	"600 767"
			}
			"3"
			{
				"name"		"Verdana"
				"tall"		"14"
				"weight"	"0"
				"yres"	"768 1023"
				"antialias"	"1"
			}
			"4"
			{
				"name"		"Verdana"
				"tall"		"20"
				"weight"	"0"
				"yres"	"1024 1199"
				"antialias"	"1"
			}
			"5"
			{
				"name"		"Verdana"
				"tall"		"24"
				"weight"	"0"
				"yres"	"1200 6000"
				"antialias"	"1"
			}
		}
		"DefaultSmallBold"
		{
			"1"
			{
				"name"		"Verdana"
				"tall"		"12"
				"weight"	"800"
				"yres"	"480 599"
			}
			"2"
			{
				"name"		"Verdana"
				"tall"		"13"
				"weight"	"800"
				"yres"	"600 767"
			}
			"3"
			{
				"name"		"Verdana"
				"tall"		"14"
				"weight"	"800"
				"yres"	"768 1023"
				"antialias"	"1"
			}
			"4"
			{
				"name"		"Verdana"
				"tall"		"20"
				"weight"	"800"
				"yres"	"1024 1199"
				"antialias"	"1"
			}
			"5"
			{
				"name"		"Verdana"
				"tall"		"24"
				"weight"	"800"
				"yres"	"1200 6000"
				"antialias"	"1"
			}
		}
		"DefaultVerySmall"
		{
			"1"
			{
				"name"		"Verdana"
				"tall"		"12"
				"weight"	"600"
				"yres"	"480 599"
			}
			"2"
			{
				"name"		"Verdana"
				"tall"		"13"
				"weight"	"600"
				"yres"	"600 767"
			}
			"3"
			{
				"name"		"Verdana"
				"tall"		"14"
				"weight"	"600"
				"yres"	"768 1023"
				"antialias"	"1"
			}
			"4"
			{
				"name"		"Verdana"
				"tall"		"20"
				"weight"	"600"
				"yres"	"1024 1199"
				"antialias"	"1"
			}
			"5"
			{
				"name"		"Verdana"
				"tall"		"24"
				"weight"	"600"
				"yres"	"1200 6000"
				"antialias"	"1"
			}
		}

		// this is the symbol font
		"Marlett"
		{
			"1"
			{
				"name"		"Marlett"
				"tall"		"11"
				"weight"	"0"
				"symbol"	"1"
				"yres"		"480 6000" // the scrollbars in career mode are not scaled, so don't scale the font either
			}
		}
	}

	//
	//////////////////// BORDERS //////////////////////////////
	//
	// describes all the border types
	Borders
	{
		BaseBorder
		{
			"inset" "0 0 1 1"
			Left
			{
				"1"
				{
					"color" "BorderDark"
					"offset" "0 1"
				}
			}

			Right
			{
				"1"
				{
					"color" "BorderBright"
					"offset" "1 0"
				}
			}

			Top
			{
				"1"
				{
					"color" "BorderDark"
					"offset" "0 0"
				}
			}

			Bottom
			{
				"1"
				{
					"color" "BorderBright"
					"offset" "0 0"
				}
			}
		}
		
		TitleButtonBorder
		{
			"inset" "0 0 1 1"
			Left
			{
				"1"
				{
					"color" "BorderBright"
					"offset" "0 1"
				}
			}

			Right
			{
				"1"
				{
					"color" "BorderDark"
					"offset" "1 0"
				}
			}

			Top
			{
				"1"
				{
					"color" "BorderBright"
					"offset" "0 0"
				}
			}

			Bottom
			{
				"1"
				{
					"color" "BorderDark"
					"offset" "0 0"
				}
			}
		}

		TitleButtonDisabledBorder
		{
			"inset" "0 0 1 1"
			Left
			{
				"1"
				{
					"color" "BgColor"
					"offset" "0 1"
				}
			}

			Right
			{
				"1"
				{
					"color" "BgColor"
					"offset" "1 0"
				}
			}
			Top
			{
				"1"
				{
					"color" "BgColor"
					"offset" "0 0"
				}
			}

			Bottom
			{
				"1"
				{
					"color" "BgColor"
					"offset" "0 0"
				}
			}
		}

		TitleButtonDepressedBorder
		{
			"inset" "1 1 1 1"
			Left
			{
				"1"
				{
					"color" "BorderDark"
					"offset" "0 1"
				}
			}

			Right
			{
				"1"
				{
					"color" "BorderBright"
					"offset" "1 0"
				}
			}

			Top
			{
				"1"
				{
					"color" "BorderDark"
					"offset" "0 0"
				}
			}

			Bottom
			{
				"1"
				{
					"color" "BorderBright"
					"offset" "0 0"
				}
			}
		}

		ScrollBarButtonBorder
		{
			"inset" "1 0 0 0"
			Left
			{
				"1"
				{
					"color" "BorderBright"
					"offset" "0 1"
				}
			}

			Right
			{
				"1"
				{
					"color" "BorderDark"
					"offset" "1 0"
				}
			}

			Top
			{
				"1"
				{
					"color" "BorderBright"
					"offset" "0 0"
				}
			}

			Bottom
			{
				"1"
				{
					"color" "BorderDark"
					"offset" "0 0"
				}
			}
		}

		ScrollBarButtonDepressedBorder
		{
			"inset" "2 2 0 0"
			Left
			{
				"1"
				{
					"color" "BorderDark"
					"offset" "0 1"
				}
			}

			Right
			{
				"1"
				{
					"color" "BorderBright"
					"offset" "1 0"
				}
			}

			Top
			{
				"1"
				{
					"color" "BorderDark"
					"offset" "0 0"
				}
			}

			Bottom
			{
				"1"
				{
					"color" "BorderBright"
					"offset" "0 0"
				}
			}
		}
		
		ButtonBorder
		{
			"inset" "0 0 0 0"
			Left
			{
				"1"
				{
					"color" "BorderBright"
					"offset" "0 1"
				}
			}

			Right
			{
				"1"
				{
					"color" "BorderDark"
					"offset" "0 0"
				}
			}

			Top
			{
				"1"
				{
					"color" "BorderBright"
					"offset" "1 1"
				}
			}

			Bottom
			{
				"1"
				{
					"color" "BorderDark"
					"offset" "0 0"
				}
			}
		}

		FrameBorder
		{
			"inset" "0 0 1 1"
			Left
			{
				"1"
				{
					"color" "ControlBG"
					"offset" "0 1"
				}
			}

			Right
			{
				"1"
				{
					"color" "ControlBG"
					"offset" "0 0"
				}
			}

			Top
			{
				"1"
				{
					"color" "ControlBG"
					"offset" "0 1"
				}
			}

			Bottom
			{
				"1"
				{
					"color" "ControlBG"
					"offset" "0 0"
				}
			}
		}

		TabBorder
		{
			"inset" "0 0 1 1"
			Left
			{
				"1"
				{
					"color" "BorderBright"
					"offset" "0 1"
				}
			}

			Right
			{
				"1"
				{
					"color" "BorderDark"
					"offset" "1 0"
				}
			}

			Top
			{
				"1"
				{
					"color" "BorderBright"
					"offset" "0 0"
				}
			}

			Bottom
			{
				"1"
				{
					"color" "BorderBright"
					"offset" "0 0"
				}
			}
		}

		TabActiveBorder
		{
			"inset" "0 0 1 0"
			Left
			{
				"1"
				{
					"color" "BorderBright"
					"offset" "0 0"
				}
			}

			Right
			{
				"1"
				{
					"color" "BorderDark"
					"offset" "1 0"
				}
			}

			Top
			{
				"1"
				{
					"color" "BorderBright"
					"offset" "0 0"
				}
			}

			Bottom
			{
				"1"
				{
					"color" "ControlBG"
					"offset" "6 2"
				}
			}
		}


		ToolTipBorder
		{
			"inset" "0 0 1 0"
			Left
			{
				"1"
				{
					"color" "BorderDark"
					"offset" "0 0"
				}
			}

			Right
			{
				"1"
				{
					"color" "BorderDark"
					"offset" "1 0"
				}
			}

			Top
			{
				"1"
				{
					"color" "BorderDark"
					"offset" "0 0"
				}
			}

			Bottom
			{
				"1"
				{
					"color" "BorderDark"
					"offset" "0 0"
				}
			}
		}

		// this is the border used for default buttons (the button that gets pressed when you hit enter)
		ButtonKeyFocusBorder
		{
			"inset" "0 0 0 0"
			Left
			{
				"1"
				{
					"color" "BorderBright"
					"offset" "0 1"
				}
			}

			Right
			{
				"1"
				{
					"color" "BorderDark"
					"offset" "0 0"
				}
			}

			Top
			{
				"1"
				{
					"color" "BorderBright"
					"offset" "1 1"
				}
			}

			Bottom
			{
				"1"
				{
					"color" "BorderDark"
					"offset" "0 0"
				}
			}
		}

		ButtonDepressedBorder
		{
			"inset" "0 0 0 0"
			Left
			{
				"1"
				{
					"color" "BorderBright"
					"offset" "0 1"
				}
			}

			Right
			{
				"1"
				{
					"color" "BorderDark"
					"offset" "0 0"
				}
			}

			Top
			{
				"1"
				{
					"color" "BorderBright"
					"offset" "1 1"
				}
			}

			Bottom
			{
				"1"
				{
					"color" "BorderDark"
					"offset" "0 0"
				}
			}
		}

		ComboBoxBorder
		{
			"inset" "0 0 1 1"
			Left
			{
				"1"
				{
					"color" "BorderDark"
					"offset" "0 1"
				}
			}

			Right
			{
				"1"
				{
					"color" "BorderBright"
					"offset" "1 0"
				}
			}

			Top
			{
				"1"
				{
					"color" "BorderDark"
					"offset" "0 0"
				}
			}

			Bottom
			{
				"1"
				{
					"color" "BorderBright"
					"offset" "0 0"
				}
			}
		}

		MenuBorder
		{
			"inset" "1 1 1 1"
			Left
			{
				"1"
				{
					"color" "BorderBright"
					"offset" "0 1"
				}
			}

			Right
			{
				"1"
				{
					"color" "BorderDark"
					"offset" "1 0"
				}
			}

			Top
			{
				"1"
				{
					"color" "BorderBright"
					"offset" "0 0"
				}
			}

			Bottom
			{
				"1"
				{
					"color" "BorderDark"
					"offset" "0 0"
				}
			}
		}
		BrowserBorder
		{
			"inset" "0 0 0 1"
			Left
			{
				"1"
				{
					"color" "BorderDark"
					"offset" "0 1"
				}
			}

			Right
			{
				"1"
				{
					"color" "BorderBright"
					"offset" "0 0"
				}
			}

			Top
			{
				"1"
				{
					"color" "BorderDark"
					"offset" "0 0"
				}
			}

			Bottom
			{
				"1"
				{
					"color" "BorderBright"
					"offset" "0 0"
				}
			}
		}


		CareerButtonBorder
		{
			"inset" "0 0 0 0"
			Left
			{
				"1"
				{
					"color" "ButtonBorder"
					"offset" "0 1"
				}
			}

			Right
			{
				"1"
				{
					"color" "ButtonBorderDark"
					"offset" "0 0"
				}
			}

			Top
			{
				"1"
				{
					"color" "ButtonBorder"
					"offset" "1 1"
				}
			}

			Bottom
			{
				"1"
				{
					"color" "ButtonBorderDark"
					"offset" "0 0"
				}
			}
		}


		CareerButtonArmedBorder
		{
			"inset" "0 0 0 0"
			Left
			{
				"1"
				{
					"color" "ButtonBorderArmed"
					"offset" "0 1"
				}
			}

			Right
			{
				"1"
				{
					"color" "ButtonBorderArmedDark"
					"offset" "0 0"
				}
			}

			Top
			{
				"1"
				{
					"color" "ButtonBorderArmed"
					"offset" "1 1"
				}
			}

			Bottom
			{
				"1"
				{
					"color" "ButtonBorderArmedDark"
					"offset" "0 0"
				}
			}
		}


		CareerButtonDepressedBorder
		{
			"inset" "0 0 0 0"
			Left
			{
				"1"
				{
					"color" "ButtonBorderDepressed"
					"offset" "0 1"
				}
				"2"
				{
					"color" "ButtonBorderDepressed"
					"offset" "1 2"
				}
			}

			Right
			{
				"1"
				{
					"color" "ButtonBorderDepressedDark"
					"offset" "0 0"
				}
				"2"
				{
					"color" "ButtonBorderDepressedDark"
					"offset" "1 1"
				}
			}

			Top
			{
				"1"
				{
					"color" "ButtonBorderDepressed"
					"offset" "1 1"
				}
				"2"
				{
					"color" "ButtonBorderDepressed"
					"offset" "2 2"
				}
			}

			Bottom
			{
				"1"
				{
					"color" "ButtonBorderDepressedDark"
					"offset" "0 0"
				}
				"2"
				{
					"color" "ButtonBorderDepressedDark"
					"offset" "1 1"
				}
			}
		}
	}
}