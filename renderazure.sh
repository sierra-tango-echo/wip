DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

OUTPUTBASE=$DIR/rendered/

mkdir -p $OUTPUTBASE/azure/orchestration/everythinginone/
underware render $DIR/orchestration/azure/everythinginone/main.json > $OUTPUTBASE/azure/orchestration/everythinginone/main.json

nodeattr -n all | while read NODE; do
  mkdir -p $OUTPUTBASE/azure/$NODE/
  cd $DIR
  find deployment/ | while read f; do
    if [ -f $f ]; then
      mkdir -p $OUTPUTBASE/azure/$NODE/`dirname $f`
      underware render $DIR/$f > $OUTPUTBASE/azure/$NODE/$f $NODE
    fi
  done
done
