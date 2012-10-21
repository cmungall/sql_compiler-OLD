/*

  This is the makespec for the sql_compiler repository
  
*/

all <-- [],
  'more README.md'.

prepare <-- ['pack.pl','pack/$Name-$Version.tgz'],
  {consult('pack.pl'),name(Name),version(Version)},
  'cd pack && swipl -g "pack_install(\'$Name-$Version.tgz\'),halt"'.

release <-- [prepare,deploy],
  {consult('pack.pl'),name(Name),version(Version)},
  'cd pack && swipl -g "pack_install(\'http://www.berkeleybop.org/~cjm/packs/$Name-$Version.tgz\'),halt"'.


% todo - use git release tags
'pack/$Name-$Version.tgz' <-- [],
  'git tag -a v$Version -m "public release" && git push --tags && echo $Version && pushd . && cd ~/releasedir && (test -d $Name && rm -rf $Name || echo making fresh) && git clone git@github.com:cmungall/$Name.git && rm -rf $Name/.git && tar zcvf $Name-$Version.tgz $Name && popd && mv ~/releasedir/$Name-$Version.tgz pack/'.



deploy <-- [],
   './deploy.sh'.


