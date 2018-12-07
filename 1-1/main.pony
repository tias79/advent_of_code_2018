use "files"

actor Main
  new create(env: Env) =>
    try
        let file_name = "input"
        let path = FilePath(env.root as AmbientAuth, file_name)?

        match OpenFile(path)
        | let file: File =>
          while file.errno() is FileOK do
            var sum : I32 = 0

            let lines = FileLines(file)
            for line in FileLines(file) do
                let sign : String val = line.substring(0, 1)
                let num = line.substring(1).i32(10)?

                if (sign.eq("+")) then
                    sum = sum + num
                else
                    sum = sum - num
                end

            end
            
            env.out.print(sum.string())
          end
        else
          env.err.print("Error opening file '" + file_name + "'")
        end
    end