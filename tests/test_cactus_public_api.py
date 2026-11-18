"""Render-only checks for the cactus-public-api chart. No cluster required."""
import pathlib
import subprocess
import unittest


ROOT = pathlib.Path(__file__).resolve().parents[1]
CHART = ROOT / "charts/cactus-public-api"


class CactusPublicApiChartTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        dep = subprocess.run(
            ["helm", "dependency", "build", str(CHART)],
            capture_output=True,
            text=True,
            check=False,
        )
        if dep.returncode != 0:
            raise unittest.SkipTest(f"helm dependency build failed: {dep.stderr}")

    def render(self, *args):
        return subprocess.run(
            ["helm", "template", "cpa", str(CHART), *args],
            capture_output=True,
            text=True,
            check=False,
        )

    def test_defaults_include_env_production_and_project_ids(self):
        result = self.render()
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertRegex(result.stdout, r"name:\s*ENV")
        self.assertRegex(result.stdout, r"value:\s*production")
        self.assertIn("PROJECT_IDS", result.stdout)
        self.assertIn("342480985197117780,342481000464384340", result.stdout)

    def test_connection_hook_targets_ping(self):
        result = self.render()
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("helm.sh/hook: test", result.stdout)
        self.assertIn("/ping", result.stdout)
        self.assertIn("cactus-public-api:80/ping", result.stdout)

    def test_shared_chart_leaves_tolerations_and_ingress_annotations_empty(self):
        result = self.render()
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertNotIn("dedicated", result.stdout)
        self.assertNotIn("alb.ingress.kubernetes.io/scheme", result.stdout)


if __name__ == "__main__":
    unittest.main()
