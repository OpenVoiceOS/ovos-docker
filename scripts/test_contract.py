#!/usr/bin/env python3
"""Fixtures for scripts/contract.py.

The contract gate is only useful if it reads the compose files the way compose does. Each case
here is one way the scan used to disagree with compose: every one of them produced a contract
that looked right and was wrong, which is the failure this gate exists to prevent.

Run: python3 scripts/test_contract.py
"""
import sys
import tempfile
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

import contract  # noqa: E402


class ContractDeriveTests(unittest.TestCase):
    def derive(self, **files) -> dict:
        """Derive a contract from compose files written into a temporary directory."""
        with tempfile.TemporaryDirectory() as tmp:
            for name, text in files.items():
                (Path(tmp) / name).write_text(text)
            original = contract.COMPOSE_DIR
            contract.COMPOSE_DIR = Path(tmp)
            try:
                return contract.derive()
            finally:
                contract.COMPOSE_DIR = original

    def test_an_empty_compose_file_is_read_as_no_services(self):
        """The glob accepts any docker-compose*.yml, and an empty one parses to None."""
        derived = self.derive(**{"docker-compose.empty.yml": "# nothing here yet\n"})
        self.assertEqual({}, derived["services"])
        self.assertEqual({}, derived["env"])
        self.assertEqual(["docker-compose.empty.yml"], derived["compose_files"])

    def test_an_escaped_dollar_is_not_a_variable(self):
        """`$$NAME` is compose's escape for a literal `$NAME`, so nothing interpolates it."""
        derived = self.derive(**{"docker-compose.yml": (
            "services:\n"
            "  app:\n"
            "    image: example/app\n"
            "    command: echo $$HOME\n"
        )})
        self.assertNotIn("HOME", derived["env"])

    def test_a_lowercase_name_is_a_variable(self):
        """Compose does not require upper case, so neither does the contract."""
        derived = self.derive(**{"docker-compose.yml": (
            "services:\n"
            "  app:\n"
            "    image: example/app\n"
            "    command: ${lower_var}\n"
        )})
        self.assertIn("lower_var", derived["env"])
        self.assertTrue(derived["env"]["lower_var"]["required"])

    def test_a_key_is_not_interpolated(self):
        """Compose substitutes into values only; a key holding a `$` is not an input."""
        derived = self.derive(**{"docker-compose.yml": (
            "services:\n"
            "  app:\n"
            "    image: example/app\n"
            "    labels:\n"
            "      $NOT_A_VALUE: literal\n"
        )})
        self.assertNotIn("NOT_A_VALUE", derived["env"])

    def test_a_pass_through_entry_is_a_required_input(self):
        """`environment: - NAME` takes NAME from the host: an input with no `$NAME` to find."""
        derived = self.derive(**{"docker-compose.yml": (
            "services:\n"
            "  app:\n"
            "    image: example/app\n"
            "    environment:\n"
            "      - PASSED_THROUGH\n"
            "      - SET_HERE=value\n"
        )})
        self.assertIn("PASSED_THROUGH", derived["env"])
        self.assertTrue(derived["env"]["PASSED_THROUGH"]["required"])
        self.assertNotIn("SET_HERE", derived["env"])

    def test_a_valueless_mapping_entry_is_a_required_input(self):
        """The mapping spelling of the same thing: `NAME:` with no value."""
        derived = self.derive(**{"docker-compose.yml": (
            "services:\n"
            "  app:\n"
            "    image: example/app\n"
            "    environment:\n"
            "      PASSED_THROUGH:\n"
            "      SET_HERE: value\n"
        )})
        self.assertIn("PASSED_THROUGH", derived["env"])
        self.assertTrue(derived["env"]["PASSED_THROUGH"]["required"])
        self.assertNotIn("SET_HERE", derived["env"])

    def test_a_default_makes_a_variable_optional(self):
        """`${VAR:-x}` can stand on its own; `${VAR:?msg}` states no default and cannot."""
        derived = self.derive(**{"docker-compose.yml": (
            "services:\n"
            "  app:\n"
            "    image: example/app\n"
            "    command: ${WITH_DEFAULT:-fallback} ${WITHOUT_DEFAULT:?must be set}\n"
        )})
        self.assertFalse(derived["env"]["WITH_DEFAULT"]["required"])
        self.assertTrue(derived["env"]["WITHOUT_DEFAULT"]["required"])

    def test_an_alternative_makes_a_variable_optional(self):
        """`${VAR+x}` and `${VAR:+x}` substitute nothing when VAR is unset.

        Compose resolves both to an empty string and warns about neither, so the compose
        stands on its own and the variable is not a required input.
        """
        derived = self.derive(**{"docker-compose.yml": (
            "services:\n"
            "  app:\n"
            "    image: example/app\n"
            "    command: ${PLUS+set} ${COLON_PLUS:+set}\n"
        )})
        self.assertFalse(derived["env"]["PLUS"]["required"])
        self.assertFalse(derived["env"]["COLON_PLUS"]["required"])

    def test_a_variable_inside_a_default_is_still_a_variable(self):
        """`${PRIMARY:-${FALLBACK}}` interpolates FALLBACK too.

        Compose warns that FALLBACK is not set, so it belongs in the contract; reading the
        expression as far as the first `}` would end it inside the default and lose it.
        """
        derived = self.derive(**{"docker-compose.yml": (
            "services:\n"
            "  app:\n"
            "    image: example/app\n"
            "    command: ${PRIMARY:-${FALLBACK}}\n"
        )})
        self.assertFalse(derived["env"]["PRIMARY"]["required"])
        self.assertIn("FALLBACK", derived["env"])
        self.assertTrue(derived["env"]["FALLBACK"]["required"])

    def test_a_single_quoted_value_is_still_interpolated(self):
        """YAML quoting does not exempt a value from interpolation.

        Compose substitutes into `command: '$HOME'` exactly as it does unquoted, so the
        contract must not treat the quote style as an escape.
        """
        derived = self.derive(**{"docker-compose.yml": (
            "services:\n"
            "  app:\n"
            "    image: example/app\n"
            "    command: '$SINGLE_QUOTED'\n"
        )})
        self.assertTrue(derived["env"]["SINGLE_QUOTED"]["required"])


if __name__ == "__main__":
    unittest.main()
