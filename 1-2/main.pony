use "files"
use "collections"

actor Main
  new create(env: Env) =>
    try
        let file_name = "input"
        let path = FilePath(env.root as AmbientAuth, file_name)?

        let input = Array[I32](10)

        match OpenFile(path)
        | let file: File =>
          while file.errno() is FileOK do
            let lines = FileLines(file)
            for line in FileLines(file) do
                let sign : String val = line.substring(0, 1)
                var num = line.substring(1).i32(10)?

                if (sign.eq("-")) then
                    num = num * -1
                end

                input.push(num)
            end
            
          end
        else
          env.err.print("Error opening file '" + file_name + "'")
        end

        let results = Map[I32, Bool]()
        var sum : I32 = 0

        while results.contains(sum) == false do
          results.update(sum, true)

          let num = input.shift()?
          sum = sum + num
          input.push(num)
        end

        env.out.print(sum.string())
    end