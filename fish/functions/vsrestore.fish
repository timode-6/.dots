# ~/.config/fish/functions/vsrestore.fish
function vsrestore --description 'Find VSCodium local history for a config file'
    for d in ~/.config/VSCodium/User/History/*/
        test -f $d/entries.json; or continue
        if grep -q -- "$argv[1]" $d/entries.json
            python -c 'import json,sys,datetime; e=json.load(open(sys.argv[1])); print(sys.argv[2]); print(e["resource"]); [print("  ", x["id"], datetime.datetime.fromtimestamp(x["timestamp"]/1000).strftime("%Y-%m-%d %H:%M")) for x in e["entries"][-6:]]' $d/entries.json $d
        end
    end
end
