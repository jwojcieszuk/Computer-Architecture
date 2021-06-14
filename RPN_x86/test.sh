echo "test #1 basic operation, should be equal 14"
./rpn '5 1 2 + 4 * + 3 -'

echo "test #2 basic operation, should be equal 40"
./rpn '12 2 3 4 * 10 5 / + * +'

echo "test #3 basic operation with signed numbers, should be equal -16"
./rpn '12 2 -3 4 * 10 -5 / + * +'

echo "underflow in addition"
./rpn '-2147483648 -1 +'

echo "overflow in addition"
./rpn '2147483647 1 +'

echo "overflow in subtraction"
./rpn '2147483647 -1 -'

echo "underflow in subtraction"
./rpn '-2147483648 1 -'

echo "underflow in multiplication"
./rpn '2147483647 -2 *'

echo "underflow in multiplication"
./rpn '-2147483648 2 *'

echo "overflow in multiplication"
./rpn '-2147483648 -1 *'

echo "overflow in multiplication"
./rpn '2147483647 2 *'

echo "underflow in divsion"
./rpn '-2147483648 -1 /'

echo "input overflow"
./rpn '2147483650 -1 +'

echo "invalid expression"
./rpn '%'
./rpn ''
./rpn '1'
./rpn '+ 2 3 +'
./rpn '4 + 2 3 +'
