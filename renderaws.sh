DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

OUTPUTBASE=$DIR/rendered/

#aws
mkdir -p $OUTPUTBASE/aws/orchestration/
underware render $DIR/orchestration/aws/everythinginone/main.yaml > $OUTPUTBASE/aws/orchestration/main.yaml
underware render $DIR/orchestration/aws/seperate_domain_and_nodes/domain.yaml > $OUTPUTBASE/aws/orchestration/domain.yaml
nodeattr -n all | while read NODE; do
  mkdir -p $OUTPUTBASE/aws/$NODE/
  underware render $DIR/orchestration/aws/seperate_domain_and_nodes/node.yaml > $OUTPUTBASE/aws/$NODE/orchestration.yaml $NODE
  cd $DIR
  find deployment/ | while read f; do 
    if [ -f $f ]; then 
      mkdir -p $OUTPUTBASE/aws/$NODE/`dirname $f`
      underware render $DIR/$f > $OUTPUTBASE/aws/$NODE/$f $NODE
    fi 
  done
done
