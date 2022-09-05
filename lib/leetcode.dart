class Solution {
  List<int> twoSum(List<int> nums, int target) {
    final Map<int, int> idxMap = {};
    for (var i = 0, len = nums.length; i < len; i++) {
      var next = target - nums[i];
      if (idxMap[next] != null) {
        return [i, idxMap[next]!];
      } else {
        idxMap[nums[i]] = i;
      }
    }
    return [];
  }
}
