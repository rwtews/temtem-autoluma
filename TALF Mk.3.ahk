-::
  $stop := 0
  $sleep := 500

  monster1 := [[1260, 1340], 52]
  monster2 := [[1660, 1740], 105]

  CoordMode, pixel,screen
  CoordMode, mouse,screen

  test(arrX, y){
    MouseClick, , arrX[1], y
    Sleep 500
    MouseClick, , arrX[2], y
    Sleep 500
  }

  Walk(ByRef key) {
    Send { %key% down }{ %key% up }
    Send { %key% down }
    Sleep 50
    Send { %key% up }
  }

  findMonster(arrX, y) {
    $newY := y + 3
    PixelSearch, Px, Py, arrX[1], $newY, arrX[2], $newY, 0x1e1e1e, 1, Fast RGB
    if ErrorLevel {
      return false
    }
    return true
  }

  scanLuma(ByRef stop, arrX, y, m) {
    Sleep $sleep
    Loop {
      PixelSearch, Px, Py, arrX[0], y, arrX[1], y, 0xfefefe, 1, Fast RGB
      if !ErrorLevel {
        MsgBox, % m
        stop := 1
      }
      if (stop) {
        return
      }
      else {
        Break
      }
    }
  }

  exitBattle() {
    Sleep 500
    MouseClick, Left, 970, 900, 1
    Sleep 500
    MouseClick, Left, 970, 900, 1
  }

  isBattle() {
    ; Busca la caja de vida de el temtem aliado #2
    PixelSearch, Px, Py, 460, 800, 500, 800, 0x1e1e1e, 0, Fast RGB
    if !ErrorLevel {
      $interfaceBattle := true
    } else {
      $interfaceBattle := false
    }

    ; Escanea la patalla entera busncado un color
    PixelSearch, Px, Py, 0, 0, 1920, 150, 0x3ce8ea, 0, Fast RGB
    if !ErrorLevel {
      $scanScreen := false
    } else {
      $scanScreen := true
    }

    return $scanScreen and $interfaceBattle
  }

  Loop {
    if isBattle() {
      Sleep 10000
      Loop, 2 {
        Sleep 1000
        if ($stop) {
          return
        }

        existMonster1 := findMonster(monster1[1], monster1[2])
        existMonster2 := findMonster(monster2[1], monster2[2])

        if existMonster1 or existMonster2 {
          if existMonster1 {
            scanLuma($stop, monster1[1], monster1[2], "Luma Found on top")
          }
          if existMonster2 {
            scanLuma($stop, monster2[1], monster2[2], "Luma Found on bottom")
          }
          if ($stop) {
            return
          }
          exitBattle()
        }
      }
      if ($stop) {
        return
      }
    } else {
      Walk(a)
      Walk(w)
      Walk(d)
      Walk(s)
    }
    if ($stop) {
      return
    }
  }

  .:: $stop := 1