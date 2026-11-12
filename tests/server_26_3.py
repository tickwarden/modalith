"""Real vanilla 26.3 RCON smoke/codec checks without synthetic players.

Requires a disposable server with core installed. Does not replace player integration QA.
"""
from pathlib import Path
import json
import os
from mcrcon import MCRcon
import nbtlib

results = []

def check(name, value):
    results.append({'test': name, 'pass': bool(value)})
    print('PASS' if value else 'FAIL', name)

with MCRcon(os.getenv('MDL_RCON_HOST', '127.0.0.1'), os.getenv('MDL_RCON_PASSWORD', 'local-test-only'), port=int(os.getenv('MDL_RCON_PORT', '25575'))) as m:
    def cmd(value):
        return m.command(value)
    def get(path):
        return nbtlib.parse_nbt(cmd('data get storage mdl:work ' + path).split('contents: ', 1)[1])
    def api(name, args=''):
        return cmd('function mdl:api/' + name + (' ' + args if args else ''))
    def draft():
        cmd('data modify storage mdl:work dialog set value {type:"minecraft:multi_action",title:{text:"Codec check"},body:[{type:"minecraft:plain_message",contents:{text:"Old"},width:300}],actions:[{label:{text:"Old"},width:150}],columns:2,pause:0b,after_action:"wait_for_response"}')
    def codec(dialog=None):
        # Store long definitions server-side to stay below the RCON command limit.
        if dialog is None:
            cmd('data modify storage mdl_test:codec dialog set from storage mdl:work dialog')
        else:
            cmd('data modify storage mdl_test:codec dialog set value ' + dialog)
        # Argument codec is parsed before @a target resolution; zero players are intentional.
        return cmd('function mdl_test:codec_26_3 with storage mdl_test:codec').strip() == 'Running function mdl_test:codec_26_3'

    check('Known-good notice passes real server codec', codec('{type:"minecraft:notice",title:{text:"Notice"}}'))
    check('Negative codec control rejects unknown dialog type', not codec('{type:"minecraft:invalid",title:{text:"Bad"}}'))
    draft()
    label = nbtlib.Compound({'label': nbtlib.Compound({'text': nbtlib.String('Quoted "label"'), 'color': nbtlib.String('gold')})})
    check('Label setter succeeds', 'returned 1' in api('button_label', label.snbt()))
    check('Label preserves quotes and component styling', str(get('dialog.actions[-1].label.text')) == 'Quoted "label"' and str(get('dialog.actions[-1].label.color')) == 'gold')
    check('Tooltip setter succeeds', 'returned 1' in api('button_tooltip', '{text:{text:"Detailed tip",color:"aqua"}}'))
    check('Tooltip retains full component', str(get('dialog.actions[-1].tooltip.color')) == 'aqua')
    check('Updated label and tooltip pass dialog codec', codec())
    check('Body clear succeeds', 'returned 1' in api('body_clear'))
    check('Body clear empties only body', len(get('dialog.body')) == 0 and len(get('dialog.actions')) == 1)
    api('body', '{text:{text:"New body"},width:220}')
    check('Body can be rebuilt after clearing', len(get('dialog.body')) == 1 and str(get('dialog.body[0].contents.text')) == 'New body')
    for value in [1, 3, 8]:
        check('Columns accepts ' + str(value), 'returned 1' in api('columns', '{columns:' + str(value) + '}') and int(get('dialog.columns')) == value and codec())
    for value in ['0', '9', '2.5d']:
        check('Columns rejects ' + value, 'returned 0' in api('columns', '{columns:' + value + '}') and int(get('dialog.columns')) == 8)
    for value in ['close', 'none', 'wait_for_response']:
        check('after_action accepts ' + value, 'returned 1' in api('after_action', '{value:"' + value + '"}') and str(get('dialog.after_action')) == value and codec())
    check('after_action rejects unknown mode without mutation', 'returned 0' in api('after_action', '{value:"invalid"}') and str(get('dialog.after_action')) == 'wait_for_response')
    cmd('data modify storage mdl:work dialog.pause set value 1b')
    api('after_action', '{value:"none"}')
    check('none forces pause false for valid codec', int(get('dialog.pause')) == 0 and codec())
    check('Legacy options delegates to validated columns', 'returned 1' in api('options', '{columns:4,escape:1b}') and int(get('dialog.columns')) == 4 and int(get('dialog.can_close_with_escape')) == 1)
    check('Legacy options rejects invalid columns', 'returned 0' in api('options', '{columns:0,escape:0b}') and int(get('dialog.columns')) == 4)
    check('Legacy options rejects invalid escape before mutation', 'returned 0' in api('options', '{columns:2,escape:2}') and int(get('dialog.columns')) == 4)
    cmd('data modify storage mdl:work dialog.actions set value []')
    check('Label rejects missing last button', 'returned 0' in api('button_label', '{label:{text:"Missing"}}'))
    check('Tooltip rejects missing last button', 'returned 0' in api('button_tooltip', '{text:{text:"Missing"}}'))
    draft()
    for kind, field, value in [('open_url', 'url', 'https://example.com'), ('suggest_command', 'command', '/help'), ('copy_to_clipboard', 'value', 'Modalith')]:
        args = json.dumps({'label': {'text': kind}, field: value})
        cmd('function mdl:action/' + kind + ' ' + args)
        check('Native ' + kind + ' codec', codec())
    cmd('function mdl:action/show_dialog {label:{text:"Nested"},dialog:{type:"minecraft:notice",title:{text:"Child"}}}')
    check('Native inline show_dialog codec', codec())
    api('action/run_command', '{label:{text:"Help"},cmd:"/help"}')
    check('Native run_command codec', codec())
    api('item', '{item:{id:"minecraft:diamond",count:1},text:{text:"Item preview"}}')
    check('Item body codec on 26.3', codec())
    cmd('data modify storage mdl:work dialog.inputs set value [{type:"minecraft:text",key:"note",label:"Text",max_length:120,width:280},{type:"minecraft:boolean",key:"toggle",label:"Toggle",initial:1b},{type:"minecraft:number_range",key:"range",label:"Range",start:0,end:100,step:5,initial:50},{type:"minecraft:single_option",key:"value",label:"Choice",options:[{id:"0",display:"A",initial:1b},{id:"1",display:"B"}]}]')
    cmd('data modify storage mdl:work dialog.actions append value {label:{text:"Submit"},action:{type:"minecraft:dynamic/run_command",template:"/trigger mdl.input set 1$(value)"}}')
    check('Four inputs and dynamic numeric submission codec', codec())
    cmd('data modify storage mdl:work dialog.type set value "minecraft:notice"')
    cmd('data modify storage mdl:work dialog.action set value {label:{text:"OK"},tooltip:{text:"Notice tip"}}')
    cmd('data remove storage mdl:work dialog.actions')
    cmd('data remove storage mdl:work dialog.columns')
    check('Notice tooltip codec', codec())
    check('Columns refuses notice without mutation', 'returned 0' in api('columns', '{columns:2}'))

Path('SERVER_26_3_RESULTS.json').write_text(json.dumps(results, indent=2) + '\n')
print(sum(x['pass'] for x in results), '/', len(results))
raise SystemExit(0 if all(x['pass'] for x in results) else 1)
