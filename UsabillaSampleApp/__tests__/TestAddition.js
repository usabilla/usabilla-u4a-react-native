const sum = require('../usabilla-react-native')

// Note: test renderer must be required after react-native.

it('adds 1 + 2 to equal 3', () => {
    expect(sum.sum(1, 2)).toBe(3);
});
