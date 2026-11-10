"""Render-only regression checks. No cluster, AWS access or credentials needed."""
import pathlib
import subprocess
import unittest


ROOT = pathlib.Path(__file__).resolve().parents[1]


class CactusPublicConfigTests(unittest.TestCase):
    def render(self, *args):
        return subprocess.run(
            ["helm", "template", "review", str(ROOT / "charts/cactus"), *args],
            capture_output=True, text=True, check=False,
        )

    def test_defaults_render_without_app_credential_injection(self):
        result = self.render()
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertNotIn("AUKI_APP_KEY", result.stdout)
        self.assertNotIn("AUKI_APP_SECRET", result.stdout)
        self.assertIn("AUKI_API_PROJECT_ID", result.stdout)
        self.assertIn("POLICY_URL", result.stdout)
        self.assertIn("EXPO_PUBLIC_POLICY_URL", result.stdout)

    def test_custom_public_endpoint_configuration_still_renders(self):
        result = self.render(
            "--set",
            "entrypointEnvVars={API_URL,DDS_URL,AUKI_API_PROJECT_ID,POLICY_URL}",
        )
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("AUKI_API_PROJECT_ID", result.stdout)
        self.assertIn("POLICY_URL", result.stdout)

    def test_legacy_credential_overrides_are_rejected(self):
        for name in ("AUKI_APP_KEY", "AUKI_APP_SECRET", "AUKI_APP_KEY_DEV", "AUKI_APP_SECRET_STAGING"):
            with self.subTest(name=name):
                result = self.render("--set", f"entrypointEnvVars={{API_URL,{name}}}")
                self.assertNotEqual(result.returncode, 0)
                self.assertIn("shared app credentials must not be injected", result.stderr)

    def test_existing_secret_cannot_bypass_override_check(self):
        result = self.render(
            "--set", "useExistingSecret=true",
            "--set", "entrypointEnvVars={AUKI_APP_SECRET}",
        )
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("shared app credentials must not be injected", result.stderr)


if __name__ == "__main__":
    unittest.main()
