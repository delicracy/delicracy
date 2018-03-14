if defined? BetterErrors
  BetterErrors.editor = proc { |file, line, column| "subl://open?url=file://#{file}&line=#{line}&column=#{column}" }
end
