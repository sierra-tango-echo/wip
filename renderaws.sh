DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

OUTPUTBASE=$DIR/rendered/

#aws
mkdir -p $OUTPUTBASE/aws/orchestration/everythinginone
mkdir -p $OUTPUTBASE/aws/orchestration/seperate_domain_and_nodes
mkdir -p $OUTPUTBASE/aws/orchestration/seperate_domain_and_group
underware render $DIR/orchestration/aws/everythinginone/main.yaml > $OUTPUTBASE/aws/orchestration/everythinginone/main.yaml
underware render $DIR/orchestration/aws/seperate_domain_and_nodes/domain.yaml > $OUTPUTBASE/aws/orchestration/seperate_domain_and_nodes/domain.yaml
underware render $DIR/orchestration/aws/seperate_domain_and_group/domain.yaml > $OUTPUTBASE/aws/orchestration/seperate_domain_and_group/domain.yaml
underware render $DIR/orchestration/aws/seperate_domain_and_group/group.yaml > $OUTPUTBASE/aws/orchestration/seperate_domain_and_group/group.yaml
nodeattr -n all | while read NODE; do
  mkdir -p $OUTPUTBASE/aws/$NODE/
  underware render $DIR/orchestration/aws/seperate_domain_and_nodes/node.yaml > $OUTPUTBASE/aws/orchestration/seperate_domain_and_nodes/$NODE.yaml $NODE
  cd $DIR
  find deployment/ | while read f; do 
    if [ -f $f ]; then 
      mkdir -p $OUTPUTBASE/aws/$NODE/`dirname $f`
      underware render $DIR/$f > $OUTPUTBASE/aws/$NODE/$f $NODE
    fi 
  done
done
