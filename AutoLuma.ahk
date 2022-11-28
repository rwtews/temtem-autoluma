*:: 
  global $stop := 0
  global $sleep := 500
  global battles := 0

  CoordMode, pixel,screen
  CoordMode, mouse,screen

  autoWalk() {
    sleepWalk := 30
    Loop { 
      if !isBattle() {
        Random, rand, 1, 4
        Random, randMove, 1, 8
        Loop, %randMove% {
          if !isBattle() {
            Random, randStop, 1, 15
            IfEqual, randStop, 1, Sleep 100

            switch rand {
            case 1:
              Send {a down} 
              Sleep sleepWalk
              Send {a up}
              Break
            case 2:
              Send {w down}
              Sleep sleepWalk 
              Send {w up}
              Break
            case 3:
              Send {d down}
              Sleep sleepWalk 
              Send {d up}
              Break
            case 4:
              Send {s down}
              Sleep sleepWalk 
              Send {s up}
              Break
            }
          } else {
            MouseClick,, 970, 900,
            Break
          }
        } 
      }
      if ($stop) {
        return 
      }
      Break
    }
  }

  findMonster(arrX, y) {
    newY := y + 2
    PixelSearch, Px, Py, arrX[1], y, arrX[2], newY, 0x1e1e1e, 1, Fast RGB
    if ErrorLevel {
      return false
    }
    return true
  }

  scanLuma(arrX, y, m) {
    PixelSearch, Px1, Py1, arrX[1], y, arrX[2], y, 0xffffff, 1, Fast RGB
    if !ErrorLevel {
      Sleep $sleep

      PixelSearch, Px2, Py2, arrX[1], y, arrX[2], y, 0xfefefe, 1, Fast RGB
      if !ErrorLevel {
        MsgBox, % m "\n Number of battles found: " battles
        $stop := 1
      }
    }
  }

  exitBattle() {
    Sleep 500
    MouseClick, Left, 970, 900, 1
    Sleep 500
    MouseClick, Left, 970, 900, 1
    Sleep 3000
  }

  isBattle() {
    PixelSearch, Px, Py, 0, 0, 1920, 150, 0x3ce8ea, 0, Fast RGB
    if !ErrorLevel {
      return false
    }
    return true
  }

  inBattle() {
    monster1 := [[1260, 1340], 52]
    monster2 := [[1660, 1740], 106]

    Loop {
      Loop, 2 {
        Sleep 2000
        if ($stop) {
          return
        }

        existMonster1 := findMonster(monster1[1], monster1[2])
        existMonster2 := findMonster(monster2[1], monster2[2])

        if existMonster1 or existMonster2 {
          battles := battles + 1
          if existMonster1 {
            scanLuma(monster1[1], monster1[2], "Luma Found on top")
          }
          if existMonster2 {
            scanLuma(monster2[1], monster2[2], "Luma Found on bottom")
          }
          if ($stop) {
            return
          }
          exitBattle()
          return
        } else {
          Sleep 6000
          return
        }
      }
      if ($stop) {
        return
      }
    }
  }

  Loop {
    if isBattle() {
      inBattle()
    }
    else {
      autoWalk()
    }
    if ($stop) {
      return
    }
  }

  -:: $stop := 1
  /:: MsgBox, % "Number of battles found: " battles
  0:: ExitApp