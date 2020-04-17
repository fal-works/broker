package broker.collision.macro;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import sneaker.types.Maybe;
import sneaker.macro.Types;
import sneaker.macro.ContextTools;
import sneaker.macro.MacroLogger.*;
import broker.collision.cell.PartitionLevel;

using sneaker.macro.extensions.ExprExtension;

class CollisionSpaceMacro {
	public static macro function build(): Null<Fields> {
		final localClassResult = ContextTools.getLocalClass();
		if (localClassResult.isFailedWarn()) return null;
		final localClass = localClassResult.unwrap();

		final maybeParameters = getMetadataParameters(localClass);
		if (maybeParameters.isNone()) return null;
		final parameters = maybeParameters.unwrap();

		final leftX = parameters.leftTop.x;
		final topY = parameters.leftTop.y;
		final rightX = parameters.rightBottom.x;
		final bottomY = parameters.rightBottom.y;
		final levelValue = parameters.level;

		final width = rightX - leftX;
		final height = bottomY - topY;
		final gridSize = 1 << levelValue;
		final leafCellPositionFactorX = gridSize / width;
		final leafCellPositionFactorY = gridSize / height;

		final classDefinition = macro class CollisionSpace {
			/**
				The x coordinate of the left-top point of the entire space.
			**/
			public static extern inline final leftX: Float = $v{leftX};

			/**
				The y coordinate of the left-top point of the entire space.
			**/
			public static extern inline final topY: Float = $v{topY};

			/**
				The x coordinate of the right-bottom point of the entire space.
			**/
			public static extern inline final rightX: Float = $v{rightX};

			/**
				The y coordinate of the right-bottom point of the entire space.
			**/
			public static extern inline final bottomY: Float = $v{bottomY};

			/**
				The width of the entire space.
			**/
			public static extern inline final width: Float = $v{width};

			/**
				The height of the entire space.
			**/
			public static extern inline final height: Float = $v{height};

			/**
				The finest `PartitionLevel` value of `this` space (i.e. the depth of quadtrees).
			**/
			public static var partitionLevel(
				get,
				never
			): broker.collision.cell.PartitionLevel;

			/**
				The size of the space grid determined by `this.partitionLevel`.
			**/
			public static extern inline final gridSize: Int = $v{gridSize};

			/**
				Factor for calculating the position of a leaf cell
				(i.e. a cell in the finest partition level) in the space grid.
			**/
			public static extern inline final leafCellPositionFactorX: Float = $v{leafCellPositionFactorX};

			/**
				Factor for calculating the position of a leaf cell
				(i.e. a cell in the finest partition level) in the space grid.
			**/
			public static extern inline final leafCellPositionFactorY: Float = $v{leafCellPositionFactorY};

			/**
				@return The local index of the leaf `Cell` that contains the position `x, y`.
			**/
			static inline function getLeafCellLocalIndex(
				x: Float,
				y: Float
			): broker.collision.cell.LocalCellIndex {
				return if (x < leftX || x >= rightX || y < topY || y >= bottomY) {
					broker.collision.cell.LocalCellIndex.none;
				} else {
					inline function toInt(v: Float)
						return banker.type_extension.FloatExtension.toInt(v);

					final cellPositionX = toInt((x - leftX) * leafCellPositionFactorX);
					final cellPositionY = toInt((y - topY) * leafCellPositionFactorY);

					final indexValue = banker.types.Bits.zip(
						banker.types.Bits.from(cellPositionX),
						banker.types.Bits.from(cellPositionY)
					);

					new broker.collision.cell.LocalCellIndex(indexValue.toInt());
				}
			}

			/**
				@return New `Quadtree` with the specified `PartitionLevel`.
			**/
			public static inline function createQuadtree(): broker.collision.Quadtree {
				return new broker.collision.Quadtree(partitionLevel);
			}

			/**
				@return `GlobalCellIndex` of the finest `Cell` that contains the given AABB.
			**/
			public static inline function getCellIndex(
				leftX: Float,
				topY: Float,
				rightX: Float,
				bottomY: Float
			): broker.collision.cell.GlobalCellIndex {
				final leftTop = getLeafCellLocalIndex(leftX, topY);
				final rightBottom = getLeafCellLocalIndex(rightX, bottomY);

				return if (leftTop.isNone() && rightBottom.isNone()) {
					broker.collision.cell.GlobalCellIndex.none;
				} else {
					var aabbLevel: broker.collision.cell.PartitionLevel;
					var aabbLocalIndex: broker.collision.cell.LocalCellIndex;

					if (leftTop == rightBottom) {
						aabbLevel = partitionLevel;
						aabbLocalIndex = leftTop;
					} else {
						aabbLevel = broker.collision.cell.LocalCellIndex.getAabbLevel(
							leftTop,
							rightBottom,
							partitionLevel
						);
						final largerLeafCellIndex = broker.collision.cell.LocalCellIndex.max(
							leftTop,
							rightBottom
						); // For avoiding `-1`
						aabbLocalIndex = largerLeafCellIndex.inRoughLevel(
							partitionLevel,
							aabbLevel
						);
					}

					aabbLocalIndex.toGlobal(aabbLevel);
				}
			}

			static extern inline function get_partitionLevel()
				return new broker.collision.cell.PartitionLevel($v{levelValue});
		};

		final buildFields = Context.getBuildFields();
		return buildFields.concat(classDefinition.fields);
	}

	static function validParameterLength(
		metadataEntry: MetadataEntry,
		validLength: Int
	): Bool {
		final parameters = metadataEntry.params;
		if (parameters == null) {
			warn("Missing parameters", metadataEntry.pos);
			return false;
		}

		return switch (parameters.length) {
			case n if (n < validLength):
				warn("Not enough parameters", metadataEntry.pos);
				false;
			case n if (n > validLength):
				warn("Too many parameters", metadataEntry.pos);
				false;
			default:
				true;
		}
	}

	static function getMetadataParameters(localClass: ClassType): Maybe<{
		leftTop: Point,
		rightBottom: Point,
		level: Int
	}> {
		var leftTop: Maybe<Point> = Maybe.none();
		var rightBottom: Maybe<Point> = Maybe.none();
		var level: Maybe<Int> = Maybe.none();

		for (metadataEntry in localClass.meta.get()) {
			final params = metadataEntry.params;

			switch metadataEntry.name {
				case ':broker.leftTop' | ':broker_leftTop':
					if (!validParameterLength(metadataEntry, 2)) return null;

					final xResult = params[0].getFloatLiteralValue();
					if (xResult.isFailedWarn()) return null;

					final yResult = params[1].getFloatLiteralValue();
					if (yResult.isFailedWarn()) return null;

					leftTop = { x: xResult.unwrap(), y: yResult.unwrap() };

				case ':broker.rightBottom' | ':broker_rightBottom':
					if (!validParameterLength(metadataEntry, 2)) return null;

					final xResult = params[0].getFloatLiteralValue();
					if (xResult.isFailedWarn()) return null;

					final yResult = params[1].getFloatLiteralValue();
					if (yResult.isFailedWarn()) return null;

					rightBottom = { x: xResult.unwrap(), y: yResult.unwrap() };

				case ':broker.partitionLevel' | ':broker_partitionLevel':
					if (!validParameterLength(metadataEntry, 1)) return null;

					final levelResult = params[0].getIntLiteralValue();
					if (levelResult.isFailedWarn()) return null;

					level = levelResult.toMaybe();

				default:
			}
		}

		if (leftTop.isNone()) {
			warn("Missing metadata: @:broker.leftTop");
			return null;
		}

		if (rightBottom.isNone()) {
			warn("Missing metadata: @:broker.rightBottom");
			return null;
		}

		if (level.isNone()) {
			warn("Missing metadata: @:broker.partitionLevel");
			return null;
		}

		return {
			leftTop: leftTop.unwrap(),
			rightBottom: rightBottom.unwrap(),
			level: level.unwrap()
		};
	}
}

private typedef Point = { x: Float, y: Float }
#end
