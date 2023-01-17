package utils
{
	public class RandomNumberUtil  
	{
		public static function getRandomNumber():Number
		{
			return getRandomRangeNumber();
		}
		
		public static function getRandomRangeNumber(minNum:int = 0, maxNum:int = 2147483647):Number
		{
			return (Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum);
		}
	}
}