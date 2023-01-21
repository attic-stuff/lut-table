/**
  * wraps integer selection values
  * @param {real} value the value to wrap
  * @param {real} left the minimum value in the set
  * @param {real} right the maximum value in the set
  */
function wrap_selection(value, left, right) {
	return value > right ? left : (value < left ? right : value);
}