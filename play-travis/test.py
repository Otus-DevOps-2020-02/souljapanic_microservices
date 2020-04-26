import unittest

class NumbersTest(unittest.TestCase):

    def test_equal(self):
        self.assertEqual(2, 2)

if __name__ == '__main__':
    unittest.main()
