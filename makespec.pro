/*

  This is the makespec for the sql_compiler repository
  
*/

all <-- [],
  'more README.md'.

release <-- ['pack.pl','pack/$Name-$Version.tgz'],
  {consult('pack.pl'),name(Name),version(Version)}.

% todo - use git release tags
'pack/$Name-$Version.tgz' <-- [],
  'git tag -a v$Version -m "public release" && echo $Version && pushd . && cd ~/releasedir && (test -d $Name && rm -rf $Name || echo making fresh) && git clone git@github.com:cmungall/$Name.git && rm -rf $Name/.git && tar zcvf $Name-$Version.tgz $Name && popd && mv ~/releasedir/$Name-$Version.tgz pack'.


deploy <-- [],
   'rsync -avz pack/ portal.open-bio.org:/home/websites/blipkit.org/html/download/pack'.

