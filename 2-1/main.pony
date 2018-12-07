use "files"
use "collections"

actor Main
  new create(env: Env) =>
    try
        let file_name = "input"
        let path = FilePath(env.root as AmbientAuth, file_name)?

        var doubles : U16 = 0
        var tripples : U16 = 0

        match OpenFile(path)
        | let file: File =>
          while file.errno() is FileOK do
            let lines = FileLines(file)
            for line in FileLines(file) do
              let map = Map[U8, U8]()
              for c in (consume line).array().values() do

                var count = map.get_or_else(c, 0) + 1
                map.update(c, count)
              end

              for x in map.values() do
                if x == 2 then
                  doubles = doubles + 1
                  break
                end
              end

              for x in map.values() do
                if x == 3 then
                  tripples = tripples + 1
                  break
                end
              end

            end            
          end
        else
          env.err.print("Error opening file '" + file_name + "'")
        end

        let result = doubles * tripples
        env.out.print(result.string())
    end