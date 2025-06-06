import { render, screen } from '@testing-library/react';
import App from '../App.jsx';

test('renders welcome heading', () => {
  render(<App />);
  const headingElement = screen.getByText(/Welcome to React App/i);
  expect(headingElement).toBeInTheDocument();
});

test('renders learn react link', () => {
  render(<App />);
  const linkElement = screen.getByText(/Learn React/i);
  expect(linkElement).toBeInTheDocument();
});
