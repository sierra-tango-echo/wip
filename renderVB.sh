DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

OUTPUTBASE=$DIR/rendered/

mkdir -p $OUTPUTBASE/virtualbox/orchestration/nodes/
nodeattr -n all | while read NODE; do
  underware render $DIR/orchestration/virtualbox/nodes/node.sh > $OUTPUTBASE/virtualbox/orchestration/nodes/$NODE.sh $NODE
done

nodeattr -n all | while read NODE; do
  mkdir -p $OUTPUTBASE/virtualbox/$NODE/
  cd $DIR
  find deployment/ | while read f; do
    if [ -f $f ]; then
      mkdir -p $OUTPUTBASE/virtualbox/$NODE/`dirname $f`
      underware render $DIR/$f > $OUTPUTBASE/virtualbox/$NODE/$f $NODE
    fi
  done
done
