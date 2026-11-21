"""2.5 RCON/codec regression checks. Run only in an isolated network namespace.

No player clients or graphical QA. Does not test the full native dialog schema.
"""
from pathlib import Path
import json
import os
import re
from local_safety import require_local_test_environment
HOST, PORT = require_local_test_environment()
from mcrcon import MCRcon
import nbtlib

results = []
def check(name, value):
    results.append({'test':name, 'pass':bool(value)})
    print(('PASS ' if value else 'FAIL ') + name, flush=True)

with MCRcon(HOST, os.getenv('MDL_RCON_PASSWORD','local-test-only'), port=PORT) as m:
    def cmd(s): return m.command(s)
    def api(name,args=''):
        if len(args)>1000:
            values=nbtlib.parse_nbt(args)
            cmd('data modify storage mdl_test:nine args set value {}')
            for key,value in values.items():
                if isinstance(value,nbtlib.List):
                    cmd('data modify storage mdl_test:nine args.'+key+' set value []')
                    for row in value:cmd('data modify storage mdl_test:nine args.'+key+' append value '+row.snbt())
                else:cmd('data modify storage mdl_test:nine args.'+key+' set value '+value.snbt())
            return cmd('function mdl:api/'+name+' with storage mdl_test:nine args')
        return cmd('function mdl:api/'+name+(' '+args if args else ''))
    def read(storage,path):
        s=cmd('data get storage '+storage+' '+path).split('contents: ',1)[1]
        s=re.sub(r'\\\\|\\[nrt]',lambda m:{'\\n':'\n','\\r':'\r','\\t':'\t'}.get(m.group(),m.group()),s)
        return nbtlib.parse_nbt(s)
    def get(path): return read('mdl:work',path)
    def draft():
        cmd('data remove storage mdl:work body_width')
        cmd('data modify storage mdl:work theme set value {}')
        cmd('data modify storage mdl:work dialog set value {type:"minecraft:multi_action",title:{text:"Nine features"},body:[],inputs:[],actions:[{label:{text:"Close"}}],columns:2,pause:0b,can_close_with_escape:1b,after_action:"wait_for_response"}')
    def codec():
        cmd('data modify storage mdl_test:codec dialog set from storage mdl:work dialog')
        return cmd('function mdl_test:codec_26_3 with storage mdl_test:codec').strip()=='Running function mdl_test:codec_26_3'
    def reject(name,fn,args):
        cmd('data modify storage mdl_test:nine before set from storage mdl:work dialog')
        response=api(fn,args)
        cmd('execute store success storage mdl_test:nine changed int 1 run data modify storage mdl_test:nine before set from storage mdl:work dialog')
        check(name, 'returned 0' in response and int(read('mdl_test:nine','changed'))==0)
    def widget(kind,**kw):
        return api('widget/'+kind,nbtlib.Compound(kw).snbt())
    def c(text):return nbtlib.Compound({'text':nbtlib.String(text)})
    def rows(n,kind):
        fields=['label','left','right'] if kind=='comparison' else ['time','title','description']
        return nbtlib.List[nbtlib.Compound]([nbtlib.Compound({f:c(f+' '+str(i)) for f in fields}) for i in range(n)])
    draft();api('diagnostics_enabled','{enabled:1}');api('diagnostics_clear')
    for level in ['info','success','warning','error']:
        check('Callout '+level+' appends', 'returned 1' in api('widget/callout','{title:{text:"Title"},description:{text:"Details"},level:"'+level+'",width:300}'))
        check('Callout '+level+' native codec',codec())
        check('Callout '+level+' marker color',str(get('dialog.body[-1].contents.extra[0].color'))=={'info':'aqua','success':'green','warning':'gold','error':'red'}[level])
    reject('Unknown callout level is atomic','widget/callout','{title:{text:"Title"},description:{text:"Details"},level:"fatal",width:300}')
    reject('Callout scalar component rejected','widget/callout','{title:"bad",description:{text:"Details"},level:"info",width:300}')
    for kind in ['comparison','timeline']:
        key='rows' if kind=='comparison' else 'events'
        base={'title':c('Quoted " title \\ $(raw)\nnext'),'width':nbtlib.Int(300)}
        if kind=='comparison':base.update(left=c('Before'),right=c('After'))
        for count in [0,1,32]:
            draft()
            args=dict(base);args[key]=rows(count,kind)
            check(kind+' accepts '+str(count), 'returned 1' in widget(kind,**args))
            check(kind+' codec '+str(count),codec())
            check(kind+' preserves quoted title '+str(count),str(get('dialog.body[-1].contents.extra[0].text'))==str(base['title']['text']))
            if count==1:
                row_index=5 if kind=='comparison' else 1
                field='label' if kind=='comparison' else 'time'
                check(kind+' preserves row order',str(get('dialog.body[-1].contents.extra['+str(row_index)+'].extra[1].text'))==field+' 0')
        for value,label in [(rows(33,kind),'33 rows'),(nbtlib.String('invalid'),'scalar list'),(nbtlib.List[nbtlib.String](['invalid']),'string list'),(nbtlib.List[nbtlib.Compound]([nbtlib.Compound({})]),'missing fields')]:
            args=dict(base);args[key]=value
            reject(kind+' rejects '+label,'widget/'+kind,nbtlib.Compound(args).snbt())
        args=dict(base);args[key]=rows(1,kind);args['width']=nbtlib.Double(2.5)
        reject(kind+' rejects fractional width','widget/'+kind,nbtlib.Compound(args).snbt())
    draft()
    for name in ['escape','pause']:
        for val in ['0','1','0b','1b','1.0d']:
            check(name+' accepts '+val,'returned 1' in api(name,'{enabled:'+val+'}') and codec())
        for val in ['2','-1','0.5d','"invalid"']:
            reject(name+' rejects '+val,name,'{enabled:'+val+'}')
    api('pause','{enabled:0}');api('after_action','{value:"none"}')
    reject('Pause true incompatible with none','pause','{enabled:1}')
    check('Pause false compatible with none','returned 1' in api('pause','{enabled:0}'))
    api('after_action','{value:"wait_for_response"}');api('pause','{enabled:1}');api('after_action','{value:"none"}')
    check('Existing none setter still normalizes pause',int(get('dialog.pause'))==0)
    check('Default body fallback is 300','returned 1' in api('body_default','{text:{text:"Default"}}') and int(get('dialog.body[-1].width'))==300)
    for width in [1,1024,240]:
        check('Set default body width '+str(width),'returned 1' in api('body_width','{width:'+str(width)+'}'))
        api('body_default','{text:{text:"Inherited"}}')
        check('Inherited width '+str(width),int(get('dialog.body[-1].width'))==width)
    api('body','{text:{text:"Explicit"},width:123}')
    check('Explicit body width wins over default',int(get('dialog.body[-1].width'))==123 and int(get('body_width'))==240)
    for val in ['0','1025','-1','1.5d','"wide"']:
        check('Invalid default width preserved '+val,'returned 0' in api('body_width','{width:'+val+'}') and int(get('body_width'))==240)
    reject('Invalid explicit width atomic','body','{text:{text:"Bad"},width:0}')
    check('Default bodies native codec',codec())
    before_actions=get('dialog.actions').snbt();before_len=len(get('dialog.body'))
    check('Replace first body','returned 1' in api('body_set','{index:0,text:{text:"Replaced",color:"gold"},width:222}'))
    check('Replacement preserves length and actions',len(get('dialog.body'))==before_len and get('dialog.actions').snbt()==before_actions)
    check('Replacement preserves styled component',str(get('dialog.body[0].contents.color'))=='gold')
    check('Replacement codec',codec())
    for name in ['body_set','body_remove']:
        for index in ['-1','1.5d','999999','2147483647','"invalid"']:
            reject(name+' invalid index '+index,name,'{index:'+index+(',text:{text:"Bad"},width:300}' if name=='body_set' else '}'))
    reject('Replacement invalid width atomic','body_set','{index:0,text:{text:"Bad"},width:1025}')
    api('item','{item:{id:"minecraft:diamond",count:1},text:{text:"Item"}}')
    last=len(get('dialog.body'))-1
    reject('Text replacement refuses item body','body_set','{index:'+str(last)+',text:{text:"Bad"},width:300}')
    check('Remove item body','returned 1' in api('body_remove','{index:'+str(last)+'}'))
    next_text=get('dialog.body[1]').snbt()
    check('Remove first body','returned 1' in api('body_remove','{index:0}') and get('dialog.body[0]').snbt()==next_text)
    check('Removal preserves actions',get('dialog.actions').snbt()==before_actions)
    cmd('data modify storage mdl:work theme.body set value {color:"aqua"}')
    api('body_set','{index:0,text:{text:"Themed"},width:300}')
    check('Replacement uses existing body theme',str(get('dialog.body[0].contents.color'))=='aqua')
    before=get('dialog').snbt()
    check('Validator accepts valid draft','returned 1' in api('validate'))
    check('Validator does not modify draft',get('dialog').snbt()==before)
    for path,value in [('columns','0'),('columns','2.5d'),('after_action','"invalid"'),('body','"bad"'),('body','[{type:"minecraft:unknown"}]'),('body','[{type:"minecraft:plain_message",contents:{text:"Bad"},width:0}]'),('title','"scalar"'),('actions','[]'),('pause','2b')]:
        draft();cmd('data modify storage mdl:work dialog.'+path+' set value '+value)
        reject('Validator rejects '+path+'='+value,'validate','')
    draft();cmd('data merge storage mdl:work {dialog:{pause:1b,after_action:"none"}}')
    reject('Validator rejects pause-none conflict','validate','')
    draft();api('notice');check('Validator accepts notice conversion','returned 1' in api('validate') and codec())
    draft();cmd('data modify storage mdl:work dialog.actions append value {label:{text:"No"}}');api('confirmation')
    check('Validator accepts confirmation conversion','returned 1' in api('validate') and codec())
    draft();api('body_clear');reject('Removing empty body fails atomically','body_remove','{index:0}')
    cmd('data remove storage mdl:work dialog')
    for name,args in [('escape','{enabled:1}'),('pause','{enabled:1}'),('body_width','{width:300}'),('body_default','{text:{text:"No"}}'),('body_set','{index:0,text:{text:"No"},width:300}'),('body_remove','{index:0}'),('validate',''),('widget/callout','{title:{text:"T"},description:{text:"D"},level:"info",width:300}')]:
        check(name+' refuses absent draft','returned 0' in api(name,args))
    check('New failures are diagnosed',int(read('mdl:log','counts.error'))>0)

Path('SERVER_NINE_RESULTS.json').write_text(json.dumps(results,indent=2)+'\n')
print(sum(x['pass'] for x in results),'/',len(results),flush=True)
raise SystemExit(0 if all(x['pass'] for x in results) else 1)
