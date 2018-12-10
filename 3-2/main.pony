use "files"
use "collections"

class val Inch is (Hashable & Equatable[Inch val])

  let _x : U16 val
  let _y : U16 val
  let _hash : USize val

  new create(x : U16 val, y : U16 val) =>
    _x = x
    _y = y

    let tmp = Array[U8](4)
    tmp.push_u16(x)
    tmp.push_u16(y)
    _hash = HashByteSeq.hash(tmp)

  fun hash(): USize =>
    _hash

  fun eq(other: Inch): Bool =>
    (other._x == _x) and (other._y == _y)

  fun ne(other: Inch): Bool =>
    (other._x != _x) or (other._y != _y)


actor Main

  new create(env: Env) =>
    var square = Map[Inch, Set[String]]()
    var sizes = Map[String, U16]()

    try
        let file_name = "input"
        let path = FilePath(env.root as AmbientAuth, file_name)?

        match OpenFile(path)
        | let file: File =>
          while file.errno() is FileOK do
            let lines = FileLines(file)
            for line in FileLines(file) do
              let cols = line.split(" ")
              let id = cols(0)?
              let coords = cols(2)?.split(",:")
              let x0 = coords(0)?.u16()?
              let y0 = coords(1)?.u16()?
              let size = cols(3)?.split("x")
              let w0 = size(0)?.u16()?
              let h0 = size(1)?.u16()?

              sizes.update(id, w0 * h0)

              var y : U16 = 0
              while y < h0 do
                var x : U16 = 0
                while x < w0 do
                  let inch = recover val Inch(y + y0, x + x0) end
                  let current = square.get_or_else(inch, Set[String]())
                  square.update(inch, current.add(id))
                  x = x + 1
                end
                y = y + 1
              end
            end            
          end
        else
          env.err.print("Error opening file '" + file_name + "'")
        end

        var tmp = Map[String, U16]()
        for value in square.values() do
          if value.size() == 1 then
            for id in value.values() do
              tmp.update(id, tmp.get_or_else(id, 0) + 1)
            end
          end
        end

        for id in tmp.keys() do
          if tmp(id)? == sizes(id)? then
            env.out.print(id)
          end
        end
     end