use "files"
use "collections"

actor Brute
  let _haystack : Array[String] val
  let _env: Env val

  new create(env: Env val, haystack: Array[String] val) =>
    _haystack = haystack
    _env = env

  be work(needle: String) =>

    try
      for str in _haystack.values() do
        let needle_arr = needle.array()
        let str_arr = str.array()
        var buf : Array[U8] iso = recover iso Array[U8]() end

        var i: USize = 0
        while i < needle_arr.size() do
          if needle_arr.read_u8(i)? == str_arr.read_u8(i)? then
            buf.push(needle_arr.read_u8(i)?)
          end

          i = i + 1
        end

        if buf.size() == (needle_arr.size() - 1) then
          _env.out.print(String.from_array(consume buf))
        end
      end
    end

actor Main
  var _input: Array[String] iso

  new create(env: Env) =>
    _input = recover iso Array[String] end

    try
        let file_name = "input"
        let path = FilePath(env.root as AmbientAuth, file_name)?

        match OpenFile(path)
        | let file: File =>
          while file.errno() is FileOK do
            let lines = FileLines(file)
            for line in FileLines(file) do
              _input.push(consume line)
            end            
          end
        else
          env.err.print("Error opening file '" + file_name + "'")
        end

        let val_it: Array[String] val = _input = recover iso Array[String] end

        for str in val_it.values() do          
          let brute = Brute(env, val_it)
          brute.work(str)
        end
     end