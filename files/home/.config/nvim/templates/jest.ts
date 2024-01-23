import { add, sub } from "./add";

beforeEach(() => {
  jest.clearAllMocks();
});

jest.mock("./div", () => {
  return { div: jest.fn(() => 99) };
});

describe("add", () => {
  it.todo("should add two numbers");
  it("test", () => {
    expect(add(1, 2)).toBe(3);
    expect({ a: 1 }).toEqual({ a: 1 });
    expect([1, 2, 3]).toContain(2);
    expect([1, 2, 3]).toEqual(expect.arrayContaining([2, 3]));
    expect("lorem").toMatch(/rem/);
    expect(true).not.toBe(false);
    expect(function () {
      throw new Error("foo");
    }).toThrow();
  });
  it("test2", () => {
    const fn = jest.fn(() => "foo");
    fn();
    expect(fn).toHaveBeenCalledTimes(1);
    expect(fn).toHaveBeenCalledWith();
    expect(fn).toHaveReturnedWith("foo");
    function foo() {}
    const obj = { foo };
    const spy = jest.spyOn(obj, "foo");
    obj.foo();
    expect(spy).toHaveBeenCalled();
  });
  it("test3", () => {
    jest.mock("./add", () => {
      return { add: jest.fn(() => 99) };
    });
    const { add: mocked } = require("./add");
    expect(mocked(1, 2)).toBe(99);
  });
  it("test4", () => {
    expect(sub()).toBe(99);
  });
});
